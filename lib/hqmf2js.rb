# Top level include file that brings in all the necessary code
require 'bundler/setup'
require 'rubygems'
require 'erb'
require 'ostruct'
require 'singleton'
require 'json'
require 'tilt'
require 'coffee_script'
require 'sprockets'
require 'nokogiri'

require_relative 'hqmf/utilities'
require_relative 'hqmf/types'
require_relative 'hqmf/document'
require_relative 'hqmf/data_criteria'
require_relative 'hqmf/population_criteria'
require_relative 'hqmf/precondition'

require_relative 'generator/js'
require_relative 'generator/codes_to_json'
require_relative 'generator/converter'

Tilt::CoffeeScriptTemplate.default_bare = true
