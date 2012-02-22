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
    def self.generate_map_reduce(hqmf_contents)
      # First compile the CoffeeScript that enables our converted HQMF JavaScript
      hqmf_utils = Rails.application.assets.find_asset('hqmf_util').to_s

      # Parse the code systems that are mapped to the OIDs we support
      codes_file_path = File.expand_path("../../test/fixtures/codes.xml", __FILE__)
      codes = Generator::CodesToJson.new(codes_file_path)
      codes_json = codes.json

      # Convert the HQMF document included as a fixture into JavaScript
      converter = Generator::JS.new(hqmf_contents)
      converted_hqmf = "#{converter.js_for_data_criteria}
                        #{converter.js_for('IPP')}
                        #{converter.js_for('DENOM')}
                        #{converter.js_for('NUMER')}
                        #{converter.js_for('DENEXCEP')}"
      
      # Pretty stock map/reduce functions that call out to our converted HQMF code stored in the functions variable
      map = "function map(patient) {
              if (IPP(patient)) {
                emit('ipp', 1);
                if (DENOM(patient)) {
                  if (NUMER(patient)) {
                    emit('denom', 1);
                    emit('numer', 1);
                  } else if (DENEXCEP(patient)) {
                    emit('denexcep', 1);
                  } else {
                    emit('denom', 1);
                    emit('antinum', 1);
                  }
                }
              }
            };"
      reduce = "function reduce(bucket, counts) {
                  var sum = 0;
                  while(counts.hasNext()){
                    sum += counts.next();
                  }
                  return sum;
                };"
      functions = "#{hqmf_utils}
                   var OidDictionary = #{codes_json};
                   #{converted_hqmf}"

      return { :map => map, :reduce => reduce, :functions => functions }
    end
  end
end