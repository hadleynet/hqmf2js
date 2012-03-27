require 'rake'
require 'rake/testtask'
require 'sprockets'
require 'tilt'
require 'fileutils'

require_relative 'lib/hqmf2js'

# Pull in any rake task defined in lib/tasks
Dir['lib/tasks/*.rake'].sort.each do |ext|
  load ext
end

$LOAD_PATH << File.expand_path("../test",__FILE__)
desc "Run basic tests"
Rake::TestTask.new("test_units") { |t|
  t.pattern = 'test/unit/*_test.rb'
  t.verbose = true
  t.warning = true
}

task :default => [:test_units,'cover_me:report']
