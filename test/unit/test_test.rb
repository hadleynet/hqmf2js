require File.expand_path("../../test_helper", __FILE__)

class PatientApiTest  < Test::Unit::TestCase
  def setup
  end
  
  def test_test
    converter = HQMF::Converter.new
    assert_equal true, converter.test
  end
end