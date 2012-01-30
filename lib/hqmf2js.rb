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
require_relative 'hqmf/restriction'
require_relative 'hqmf/comparison'

require_relative 'generator/js'
