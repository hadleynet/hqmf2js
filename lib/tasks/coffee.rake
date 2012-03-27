namespace :coffee do
  desc 'Compile the CoffeeScript library'
  task :compile do
    ctx = Sprockets::Environment.new(File.expand_path("../../..", __FILE__))
    Tilt::CoffeeScriptTemplate.default_bare=true 
    ctx.append_path "app/assets/javascripts"
    api = ctx.find_asset('hqmf_util')
    
    Dir.mkdir('tmp') unless Dir.exists?( 'tmp')
    
    File.open('tmp/hqmf.js', 'w+') do |js_file|
      js_file.write api
    end
  end
end