require 'cover_me'

if RUBY_PLATFORM=='java'
  require 'rhino'
else
  require 'v8'
end

PROJECT_ROOT = File.expand_path("../../", __FILE__)
require File.join(PROJECT_ROOT, 'lib', 'hqmf2js')

require 'test/unit'