require File.expand_path("../../test_helper", __FILE__)

class InterRestrictionsTest  < Test::Unit::TestCase
  def setup
    path = File.expand_path("../../fixtures/inter_comparison_restrictions.xml", __FILE__)
    doc = Nokogiri::XML(File.new(path))
    doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')
    @precondition = HQMF::Precondition.new(doc.root(), nil, nil)
  end
  
  def test_metadata
    assert_equal "AND", @precondition.conjunction
    assert_equal 1, @precondition.preconditions.length
    assert_equal "OR", @precondition.preconditions[0].conjunction
    assert @precondition.preconditions[0].comparison
    assert_equal 2, @precondition.preconditions[0].comparison.restrictions.length
    assert_equal 1, @precondition.restrictions.length
    assert_equal 'SBS', @precondition.restrictions[0].type
    assert_equal 3, @precondition.restrictions[0].preconditions.length
    assert_equal 'OR', @precondition.restrictions[0].preconditions[0].conjunction
    assert_equal 1, @precondition.restrictions[0].preconditions[0].restrictions.length
    assert_equal 'SBS', @precondition.restrictions[0].preconditions[0].restrictions[0].type
    #assert_not_nil @precondition.restrictions[0].preconditions[0].restrictions[0].comparison
  end
end
