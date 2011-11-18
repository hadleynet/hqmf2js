require File.expand_path("../../test_helper", __FILE__)

class NestingTest  < Test::Unit::TestCase
  def setup
    path = File.expand_path("../../fixtures/precondition_nesting.xml", __FILE__)
    doc = Nokogiri::XML(File.new(path))
    doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')
    @precondition = HQMF::Precondition.new(doc.root(), nil, nil)
  end
  
  def test_metadata
    assert_equal "AND", @precondition.conjunction
    assert @precondition.negation
    assert_equal 1, @precondition.preconditions.length
    assert_equal "AND", @precondition.preconditions[0].conjunction
    assert_equal false, @precondition.preconditions[0].negation
    assert_equal "FIRST", @precondition.preconditions[0].subset
    assert @precondition.preconditions[0].comparison
    assert_equal "FIRST", @precondition.preconditions[0].comparison.subset
    assert_equal 1, @precondition.preconditions[0].comparison.restrictions.length
    assert_equal "CONCURRENT", @precondition.preconditions[0].comparison.restrictions[0].type
    assert_equal "SECOND", @precondition.preconditions[0].comparison.restrictions[0].subset
    assert @precondition.preconditions[0].comparison.restrictions[0].comparison
    assert_equal "Procedure performed: unilateral mastectomy", @precondition.preconditions[0].comparison.restrictions[0].comparison.title
  end
end
