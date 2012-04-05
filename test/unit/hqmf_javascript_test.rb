require_relative '../test_helper'

class HqmfJavascriptTest < Test::Unit::TestCase
  def setup
    # Open a path to all of our fixtures
    hqmf_contents = File.open("test/fixtures/NQF59New.xml").read
    codes_file_path = File.expand_path("../../fixtures/codes.xml", __FILE__)
    # This patient is identified from Cypress as in the denominator and numerator for NQF59
    numerator_patient_json = File.read('test/fixtures/patients/larry_vanderman.json')
    
    # First compile the CoffeeScript that enables our converted HQMF JavaScript
    ctx = Sprockets::Environment.new(File.expand_path("../../..", __FILE__))
    Tilt::CoffeeScriptTemplate.default_bare = true 
    ctx.append_path "app/assets/javascripts"
    hqmf_utils = HQMF2JS::HqmfUtility.hqmf_utility_javascript.to_s
    
    # Parse the code systems that are mapped to the OIDs we support
    codes = HQMF2JS::Generator::CodesToJson.new(codes_file_path)
    codes_json = codes.json
    
    # Convert the HQMF document included as a fixture into JavaScript
    converter = HQMF2JS::Generator::JS.new(hqmf_contents)
    converted_hqmf = "#{converter.js_for_data_criteria}
      #{converter.js_for('IPP')}
      #{converter.js_for('DENOM')}
      #{converter.js_for('NUMER')}
      #{converter.js_for('DENEXCEP')}
      #{converter.js_for('DUMMY')}"
    
    # Now we can wrap and compile all of our code as one little JavaScript context for all of the tests below
    patient_api = File.open('test/fixtures/patient_api.js').read
    fixture_json = File.read('test/fixtures/patients/larry_vanderman.json')
    initialize_patient = 'var numeratorPatient = new hQuery.Patient(larry);'
    if RUBY_PLATFORM=='java'
      @context = Rhino::Context.new
    else
      @context = V8::Context.new
    end
    @context.eval("#{hqmf_utils}
      var OidDictionary = #{codes_json};
      #{converted_hqmf}
      #{patient_api}
      var larry = #{fixture_json};
      #{initialize_patient}")
  end
  
  def test_codes
    # Make sure we're recalling entries correctly
    assert_equal 1, @context.eval('OidDictionary["2.16.840.1.113883.3.464.1.14"]').count
    assert_equal "00110", @context.eval('OidDictionary["2.16.840.1.113883.3.464.1.14"]["HL7"][0]')
    
    # OIDs that are matched to multiple code systems should also work correctly
    # The list of supported OIDs will eventually be long, so this won't be an exhaustive test, just want to be sure the functionality is right
    assert_equal 3, @context.eval('OidDictionary["2.16.840.1.113883.3.464.1.72"]').count
    assert_equal 2, @context.eval('OidDictionary["2.16.840.1.113883.3.464.1.72"]["CPT"]').count
    assert_equal 3, @context.eval('OidDictionary["2.16.840.1.113883.3.464.1.72"]["LOINC"]').count
    assert_equal 9, @context.eval('OidDictionary["2.16.840.1.113883.3.464.1.72"]["SNOMED-CT"]').count
  end
  
  def test_converted_hqmf
    # Measure variables
    assert_equal 2011, @context.eval("MeasurePeriod.low.asDate().getFullYear()")
    assert_equal 0, @context.eval("MeasurePeriod.low.asDate().getMonth()")
    assert_equal 2011, @context.eval("MeasurePeriod.high.asDate().getFullYear()")
    assert_equal 11, @context.eval("MeasurePeriod.high.asDate().getMonth()")
    assert_equal 1, @context.eval("MeasurePeriod.width.value")
    assert_equal 'a', @context.eval("MeasurePeriod.width.unit")
  
    # Age functions - Fixture is 37.1
    assert @context.eval("ageBetween17and64(numeratorPatient)")
    assert @context.eval("ageBetween30and39(numeratorPatient)")
    assert !@context.eval("ageBetween17and21(numeratorPatient)")
    assert !@context.eval("ageBetween22and29(numeratorPatient)")
    assert !@context.eval("ageBetween40and49(numeratorPatient)")
    assert !@context.eval("ageBetween50and59(numeratorPatient)")
    assert !@context.eval("ageBetween60and64(numeratorPatient)")
    
    # Gender functions - Fixture is male
    assert @context.eval("genderMale(numeratorPatient)")
    assert !@context.eval("genderFemale(numeratorPatient)")
    
    # Be sure the actual mechanic of code lists being returned works correctly - Using HasDiabetes as an example
    results = @context.eval("HasDiabetes(numeratorPatient)").first['json']
    assert_equal 3, results['codes'].count
    assert_equal '250', results['codes']['ICD-9-CM'].first
    assert_equal 1270094400, results['time']
    
    # Encounters
    assert_equal 0, @context.eval("EDorInpatientEncounter(numeratorPatient)").count
    assert_equal 0, @context.eval("AmbulatoryEncounter(numeratorPatient)").count
    
    # Conditions
    assert_equal 1, @context.eval("HasDiabetes(numeratorPatient)").count
    assert_equal 0, @context.eval("HasGestationalDiabetes(numeratorPatient)").count
    assert_equal 0, @context.eval("HasPolycysticOvaries(numeratorPatient)").count
    assert_equal 0, @context.eval("HasSteroidInducedDiabetes(numeratorPatient)").count
    
    # Results
    assert_equal 1, @context.eval("HbA1C(numeratorPatient)").count
    
    # Medications
    assert_equal 1, @context.eval("DiabetesMedAdministered(numeratorPatient)").count
    assert_equal 0, @context.eval("DiabetesMedIntended(numeratorPatient)").count
    assert_equal 0, @context.eval("DiabetesMedSupplied(numeratorPatient)").count
    assert_equal 0, @context.eval("DiabetesMedOrdered(numeratorPatient)").count
    
    # Standard population health query buckets
    assert @context.eval("IPP(numeratorPatient)")
    assert @context.eval("DENOM(numeratorPatient)")
    assert @context.eval("NUMER(numeratorPatient)")
    assert !@context.eval("DENEXCEP(numeratorPatient)")
  end
  
  def test_converted_utils
    # PQ - Value unit pair
    pq = "new PQ(1, 'mo')"
    assert_equal 1, @context.eval("#{pq}.value")
    assert_equal "mo", @context.eval("#{pq}.unit")
    assert @context.eval("#{pq}.lessThan(3)")
    assert @context.eval("#{pq}.greaterThan(0)")
    assert @context.eval("#{pq}.match(1)")
    
    # TS - Timestamp 2010-01-01
    assert_equal 2010, @context.eval("StartDate.asDate().getFullYear()")
    assert_equal 0, @context.eval("StartDate.asDate().getMonth()")
    assert_equal 1, @context.eval("StartDate.asDate().getDate()")
    assert_equal 2011, @context.eval("StartDate.add(new PQ(1, 'a')).asDate().getFullYear()")
    assert_equal 2, @context.eval("StartDate.add(new PQ(1, 'd')).asDate().getDate()")
    assert_equal 1, @context.eval("StartDate.add(new PQ(1, 'h')).asDate().getHours()")
    assert_equal 5, @context.eval("StartDate.add(new PQ(5, 'min')).asDate().getMinutes()")
    assert_equal 11, @context.eval("StartDate.add(new PQ(-1, 'mo')).asDate().getMonth()")
    
    # CD - Code
    cd = "new CD('M')"
    assert_equal 'M', @context.eval("#{cd}.code")
    assert @context.eval("#{cd}.match('M')")
    assert !@context.eval("#{cd}.match('F')")
    
    # IVL - Range
    ivl = "new IVL(new PQ(1, 'mo'), new PQ(10, 'mo'))"
    assert_equal 1, @context.eval("#{ivl}.low_pq.value")
    assert_equal 10, @context.eval("#{ivl}.high_pq.value")
    assert @context.eval("#{ivl}.match(5)")
    assert !@context.eval("#{ivl}.match(0)")
    assert !@context.eval("#{ivl}.match(11)")
    # IVL with null values on the ends
    assert @context.eval("new IVL(null, new PQ(10, 'mo')).match(5)")
    assert !@context.eval("new IVL(null, new PQ(10, 'mo')).match(11)")
    assert @context.eval("new IVL(new PQ(1, 'mo'), null).match(2)")
    assert !@context.eval("new IVL(new PQ(1, 'mo'), null).match(0)")
    
    # atLeastOneTrue
    assert !@context.eval("atLeastOneTrue()")
    assert !@context.eval("atLeastOneTrue(false, false, false)")
    assert @context.eval("atLeastOneTrue(false, true, false)")
    
    # All true
    assert !@context.eval("allTrue()")
    assert !@context.eval("allTrue(true, true, false)")
    assert @context.eval("allTrue(true, true, true)")
    
    # Matching value
    assert @context.eval("matchingValue(5, new IVL(PQ(3, 'mo'), new PQ(9, 'mo')))")
    assert !@context.eval("matchingValue(12, new IVL(PQ(3, 'mo'), new PQ(9, 'mo')))")
    
    # Filter events by value - HbA1C as an example
    events = 'numeratorPatient.results().match(getCodes("2.16.840.1.113883.3.464.1.72"))'
    assert_equal 2, @context.eval("filterEventsByValue(#{events}, new IVL(new PQ(9, '%'), null))").count
    assert_equal 0, @context.eval("filterEventsByValue(#{events}, new IVL(new PQ(10, '%'), null))").count
    
    # PREVSUM
    # TODO - Not sure what this is supposed to do. Currently does nothing.
    
    # RECENT - HbA1C as an example
    events = 'numeratorPatient.results().match(getCodes("2.16.840.1.113883.3.464.1.72"))'
    assert_equal 1, @context.eval("RECENT(#{events})").count
    assert_equal 1285992000000, @context.eval("RECENT(#{events})[0].date().getTime()")
    
    # getCode
    assert_equal 1, @context.eval('getCodes("2.16.840.1.113883.3.464.1.14")').count
    assert_equal "00110", @context.eval('getCodes("2.16.840.1.113883.3.464.1.14")["HL7"][0]')
  end
  
  def test_map_reduce_generation
    hqmf_contents = File.open("test/fixtures/NQF59New.xml").read
    map_reduce = HQMF2JS::Converter.generate_map_reduce(hqmf_contents)
    
    # Extremely loose testing here. Just want to be sure for now that we're getting results of some kind.
    # We'll test for validity over on the hQuery Gateway side of things.
    assert map_reduce[:map].include? 'map'
    assert map_reduce[:reduce].include? 'reduce'
    # Check functions to include actual HQMF converted function, HQMF utility function, and OID dictionary
    assert map_reduce[:functions].include? 'IPP'
    assert map_reduce[:functions].include? 'atLeastOneTrue'
    assert map_reduce[:functions].include? 'OidDictionary'
  end
end