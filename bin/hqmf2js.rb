#! /usr/bin/env ruby
require_relative '../lib/hqmf2js'

if ARGV.length != 1 || !File.exists?(ARGV[0])
  puts "Usage: hqmf2js hqmf_file"
else
  hqmf_contents = File.open(ARGV[0]).read
  gen = HQMF2JS::Generator::JS.new(hqmf_contents)
  
  codes = HQMF2JS::Generator::CodesToJson.new(File.expand_path("../../test/fixtures/codes.xml", __FILE__))
  codes_json = codes.json
  puts "var OidDictionary = #{codes_json};"
  
  ctx = Sprockets::Environment.new(File.expand_path("../..", __FILE__))
  Tilt::CoffeeScriptTemplate.default_bare = true 
  ctx.append_path "app/assets/javascripts"
  hqmf_utils = ctx.find_asset('hqmf_util').to_s
  puts hqmf_utils
  
  puts gen.js_for_data_criteria()
  puts gen.js_for('IPP')
  puts gen.js_for('DENOM')
  puts gen.js_for('NUMER')
  puts gen.js_for('DENEXCEP')
end