ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)

PROJECT_ROOT = File.expand_path("../../", __FILE__)
require File.join(PROJECT_ROOT, 'lib', 'hqmf2js')

require 'rails/test_help'
require 'tilt'
require 'coffee_script'
require 'sprockets'
require 'execjs'