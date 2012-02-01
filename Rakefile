require 'rake'
require 'rake/testtask'
require 'sprockets'
require 'tilt'
require 'fileutils'

# Pull in any rake task defined in lib/tasks
Dir['lib/tasks/*.rake'].sort.each do |ext|
  load ext
end

# Add a rake task for unit tests
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/unit/test*.rb']
  t.verbose = true
end