require File.join(__FILE__,'../../../hqmf2js')

namespace :hqmf do

  desc 'Convert a HQMF file to JavaScript'
  task :convert, [:file] do |t, args|
    f = args.file
    gen = Generator::JS.new(f)
#    puts gen.js_for_attributes()
    puts gen.js_for_data_criteria()
    puts gen.js_for('IPP')
    puts gen.js_for('DENOM')
    puts gen.js_for('NUMER')
    puts gen.js_for('DENEXCEP')
  end
end
    