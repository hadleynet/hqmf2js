require File.expand_path("../../test_helper", __FILE__)

class DocumentTest  < Test::Unit::TestCase
  def setup
    @hqmf_file_path = File.expand_path("../../fixtures/NQF59New.xml", __FILE__)
    @doc = HQMF::Document.new(@hqmf_file_path)
  end
  
  def test_parse
    doc = HQMF::Document.parse(@hqmf_file_path)
    assert_equal 'QualityMeasureDocument', doc.root.name
    assert_equal 'urn:hl7-org:v3', doc.root.namespace.href 
  end
  
  def test_metadata
    assert_equal "Sample Quality Measure Document", @doc.title
    assert_equal "This is the measure description.", @doc.description
  end
  
  def test_attributes
    attr_list = @doc.all_attributes
    assert_equal 0, attr_list.length

#     attr = @doc.attribute_for_code('MSRTP')
#     assert_equal 'F8D5AD22-F49E-4181-B886-E5B12BEA8966', attr.id
#     assert_equal '12', attr.value
#     assert_equal 'm', attr.unit
#     assert_equal 'Measurement period', attr.name
# 
#     attr = @doc.attribute('F8D5AD22-F49E-4181-B886-E5B12BEA8966e')
#     assert_equal 'MSRED', attr.code
#     assert_equal '00001231', attr.value
#     assert_equal nil, attr.unit
#     assert_equal 'Measurement end date', attr.name
# 
#     attr = @doc.attribute_for_code('MSRTP')
#     assert_equal 'Measurement period', attr.name
  end
  
  def test_population_criteria
    all_population_criteria = @doc.all_population_criteria
    assert_equal 6, all_population_criteria.length
#     
#     codes = all_population_criteria.collect {|p| p.code}
#     %w(IPP DENOM NUMER EXCL).each do |c|
#       assert codes.include?(c)
#     end
#     
#     ipp = @doc.population_criteria_for_code('IPP')
#     assert_equal 1, ipp.preconditions.length
#     assert_equal 0, ipp.preconditions[0].preconditions.length
#     assert_equal 'AND', ipp.preconditions[0].conjunction
#     assert_equal '52A541D7-9C22-4633-8AEC-389611894672', ipp.preconditions[0].comparison.data_criteria_id
#     assert_equal 1, ipp.preconditions[0].comparison.restrictions.length
#     assert_equal 'SBS', ipp.preconditions[0].comparison.restrictions[0].type
#     assert_equal 'F8D5AD22-F49E-4181-B886-E5B12BEA8966', ipp.preconditions[0].comparison.restrictions[0].target_id
#     assert_equal '64', ipp.preconditions[0].comparison.restrictions[0].range.low.value
#     assert_equal 'a', ipp.preconditions[0].comparison.restrictions[0].range.low.unit
#     assert_equal true, ipp.preconditions[0].comparison.restrictions[0].range.low.inclusive?
#     assert_equal nil, ipp.preconditions[0].comparison.restrictions[0].range.high
# 
#     den = @doc.population_criteria_for_code('DENOM')
#     assert_equal 1, den.preconditions.length
#     assert_equal 'AND', den.preconditions[0].conjunction
#     assert_equal '3CF573A8-34AE-408E-88D7-26A1016A140D', den.preconditions[0].comparison.data_criteria_id
#     assert_equal 1, den.preconditions[0].comparison.restrictions.length
#     assert_equal 'DURING', den.preconditions[0].comparison.restrictions[0].type
#     assert_equal 'F8D5AD22-F49E-4181-B886-E5B12BEA8966', den.preconditions[0].comparison.restrictions[0].target_id
#     
#     num = @doc.population_criteria_for_code('NUMER')
#     assert_equal 1, num.preconditions.length
#     assert_equal 'AND', num.preconditions[0].conjunction
#     assert_equal nil, num.preconditions[0].comparison
#     assert_equal 2, num.preconditions[0].preconditions.length
#     assert_equal 1, num.preconditions[0].restrictions.length
#     assert_equal 'DURING', num.preconditions[0].restrictions[0].type
#     assert_equal 'F8D5AD22-F49E-4181-B886-E5B12BEA8966', num.preconditions[0].restrictions[0].target_id
#     assert_equal 0, num.preconditions[0].preconditions[0].preconditions.length
#     assert_equal 'OR', num.preconditions[0].preconditions[0].conjunction
#     assert_equal '10165EC8-53EE-4242-A20D-B1D21CE0DC73', num.preconditions[0].preconditions[0].comparison.data_criteria_id
#     assert_equal 1, num.preconditions[0].preconditions[0].comparison.restrictions.length
#     assert_equal 'DURING', num.preconditions[0].preconditions[0].comparison.restrictions[0].type
#     assert_equal 'F8D5AD22-F49E-4181-B886-E5B12BEA8966', num.preconditions[0].preconditions[0].comparison.restrictions[0].target_id
#     assert_equal 0, num.preconditions[0].preconditions[1].preconditions.length
#     assert_equal 'OR', num.preconditions[0].preconditions[1].conjunction
#     assert_equal '482902EC-E214-4FB4-8C5A-85A41250573C', num.preconditions[0].preconditions[1].comparison.data_criteria_id
#     assert_equal 1, num.preconditions[0].preconditions[1].comparison.restrictions.length
#     assert_equal 'DURING', num.preconditions[0].preconditions[1].comparison.restrictions[0].type
#     assert_equal 'F8D5AD22-F49E-4181-B886-E5B12BEA8966', num.preconditions[0].preconditions[1].comparison.restrictions[0].target_id
#     
#     excl = @doc.population_criteria_for_code('EXCL')
#     assert_equal 0, excl.preconditions.length
  end
  
  def test_data_criteria
    data_criteria = @doc.all_data_criteria
    assert_equal 22, data_criteria.length
    
    criteria = @doc.data_criteria('EndDate')
    assert_equal :variable, criteria.type
    assert_equal 'EndDate', criteria.title
    assert_equal HQMF::Value, criteria.value.class
    assert_equal '20101231', criteria.value.value
    assert_equal 'TS', criteria.value.type

    criteria = @doc.data_criteria('ageBetween17and64')
    assert_equal :characteristic, criteria.type
    assert_equal 'ageBetween17and64', criteria.title
    assert_equal :age, criteria.property
    assert_equal HQMF::Range, criteria.value.class
    assert_equal 'IVL_PQ', criteria.value.type
    assert_equal '17', criteria.value.low.value
    assert_equal 'a', criteria.value.low.unit
    assert_equal false, criteria.value.low.derived?
    assert_equal '64', criteria.value.high.value
    assert_equal 'a', criteria.value.high.unit
    assert_equal false, criteria.value.high.derived?

    criteria = @doc.data_criteria('genderMale')
    assert_equal :characteristic, criteria.type
    assert_equal 'genderMale', criteria.title
    assert_equal :gender, criteria.property
    assert_equal HQMF::Coded, criteria.value.class
    assert_equal 'CD', criteria.value.type
    assert_equal 'M', criteria.value.code
    assert_equal '2.16.840.1.113883.5.1', criteria.value.system

    criteria = @doc.data_criteria('EDorInpatientEncounter')
    assert_equal :encounter, criteria.type
    assert_equal 'EDorInpatientEncounter', criteria.title
    assert_equal '2.16.840.1.113883.3.464.1.42', criteria.code_list_id
    assert criteria.effective_time
    assert_equal nil, criteria.effective_time.low
    assert criteria.effective_time.high
    assert_equal true, criteria.effective_time.high.derived?
    assert_equal 'EndDate.add(new PQ(-2,"a"))', criteria.effective_time.high.expression

    criteria = @doc.data_criteria('HasGestationalDiabetes')
    assert_equal :diagnosis, criteria.type
    assert_equal 'HasGestationalDiabetes', criteria.title
    assert_equal '2.16.840.1.113883.3.464.1.67', criteria.code_list_id
    assert criteria.effective_time
    assert criteria.effective_time.low
    assert_equal true, criteria.effective_time.low.derived?
    assert_equal 'StartDate', criteria.effective_time.low.expression
    assert criteria.effective_time.high
    assert_equal true, criteria.effective_time.high.derived?
    assert_equal 'EndDate', criteria.effective_time.high.expression

    criteria = @doc.data_criteria('HbA1C')
    assert_equal :result, criteria.type
    assert_equal 'HbA1C', criteria.title
    assert_equal '2.16.840.1.113883.3.464.1.72', criteria.code_list_id
    assert_equal 'completed', criteria.status
    assert_equal nil, criteria.effective_time
    assert_equal HQMF::Range, criteria.value.class
    assert_equal nil, criteria.value.high
    assert criteria.value.low
    assert_equal '9', criteria.value.low.value
    assert_equal '%', criteria.value.low.unit

    criteria = @doc.data_criteria('DiabetesMedAdministered')
    assert_equal :medication, criteria.type
    assert_equal 'DiabetesMedAdministered', criteria.title
    assert_equal '2.16.840.1.113883.3.464.1.94', criteria.code_list_id
    assert criteria.effective_time
    assert_equal nil, criteria.effective_time.low
    assert criteria.effective_time.high
    assert_equal true, criteria.effective_time.high.derived?
    assert_equal 'EndDate.add(new PQ(-2,"a"))', criteria.effective_time.high.expression

    criteria = @doc.data_criteria('DiabetesMedSupplied')
    assert_equal :medication, criteria.type
    assert_equal 'DiabetesMedSupplied', criteria.title
    assert_equal '2.16.840.1.113883.3.464.1.94', criteria.code_list_id
    assert criteria.effective_time
    assert_equal nil, criteria.effective_time.low
    assert criteria.effective_time.high
    assert_equal true, criteria.effective_time.high.derived?
    assert_equal 'EndDate.add(new PQ(-2,"a"))', criteria.effective_time.high.expression

    begin
      criteria = @doc.data_criteria('foo')
      assert false, "Should raise exception for unknown data criteria"
    rescue => detail
    end
  end
  
end