require 'rake'
require 'rake/testtask'

Dir['lib/tasks/*.rake'].sort.each do |ext|
  load ext
end

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/unit/test*.rb']
  t.verbose = true
end