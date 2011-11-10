require File.expand_path("../../test_helper", __FILE__)

class GeneratorTest  < Test::Unit::TestCase
  def setup
    @hqmf_file_path = File.expand_path("../../fixtures/NQF_Retooled_Measure_0043.xml", __FILE__)
    @gen = Generator::JS.new(@hqmf_file_path)
  end
  
  def test_data_criteria
    js = @gen.js_for_data_criteria()
    puts js
  end
  
  def test_attributes
    js = @gen.js_for_attributes()
    puts js
  end

  def test_ipp
    js = @gen.js_for('IPP')
    puts js
  end

  def test_den
    js = @gen.js_for('DENOM')
    puts js
  end

  def test_num
    js = @gen.js_for('NUMER')
    puts js
  end

end