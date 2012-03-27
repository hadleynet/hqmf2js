namespace :codes do
  desc 'Convert code systems from XML to JSON'
  task :convert, [:file] do |t, args|
    f = args.file
    codes_to_json = HQMF2JS::Generator::CodesToJson.new(f)
    
    Dir.mkdir('tmp') unless Dir.exists?('tmp')
    File.open('tmp/codes.js', 'w+') do |js_file|
      js_file.write codes_to_json.json
    end
  end
end
