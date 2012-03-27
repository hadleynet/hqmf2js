namespace :hqmf do
  desc 'Convert a HQMF file to JavaScript'
  task :convert, [:file] do |t, args|
    hqmf_contents = File.open(args.file).read
    gen = HQMF2JS::Generator::JS.new(hqmf_contents)

    codes = HQMF2JS::Generator::CodesToJson.new(File.expand_path("../../../test/fixtures/codes.xml", __FILE__))
    codes_json = codes.json
    puts "var OidDictionary = #{codes_json};"
    
    ctx = Sprockets::Environment.new(File.expand_path("../../..", __FILE__))
    Tilt::CoffeeScriptTemplate.default_bare = true 
    ctx.append_path "app/assets/javascripts"
    hqmf_utils = ctx.find_asset('hqmf_util').to_s
    puts hqmf_utils

    puts gen.js_for_data_criteria()
    puts gen.js_for('IPP')
    puts gen.js_for('DENOM')
    puts gen.js_for('NUMER')
    puts gen.js_for('DENEXCEP')
    
    if defined? Rails
      puts Rails.application.assets.find_asset('patient').to_s
    
      fixture_json = File.read('test/fixtures/patients/larry_vanderman.json')
      initialize_patient = 'var numeratorPatient = new hQuery.Patient(larry);'
      puts "var larry = #{fixture_json};"
      puts "#{initialize_patient}"
    end
  end
end
    