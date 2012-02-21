# Top level include file that brings in all the necessary code
require 'bundler/setup'

require 'nokogiri'
require 'erb'
require 'ostruct'
require 'singleton'
require 'json'

require_relative 'hqmf/utilities'
require_relative 'hqmf/types'
require_relative 'hqmf/document'
require_relative 'hqmf/data_criteria'
require_relative 'hqmf/attribute'
require_relative 'hqmf/population_criteria'
require_relative 'hqmf/precondition'

require_relative 'generator/js'
require_relative 'generator/codes_to_json'

module HQMF2JS
  class Converter
    # This method does it all. Given an HQMF file and the OIDs that we expect to use, this will use all of the other
    # helper functions below to create one MapReduce job.
    def generate_map_reduce(hqmf_doc, codes_doc)
      codes_to_json = Generator::CodesToJson.new(f)      
      
      Dir.mkdir('tmp') unless Dir.exists?('tmp')
      File.open('tmp/codes.js', 'w+') do |js_file|
        js_file.write codes_to_json.json
      end
    end
  end
  
  def self.patient_api_javascript
    Tilt::CoffeeScriptTemplate.default_bare=true
    Rails.application.assets.find_asset("patient").to_s
  end
end