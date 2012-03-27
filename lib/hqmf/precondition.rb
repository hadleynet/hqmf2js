module HQMF
  
  class Precondition
  
    include HQMF::Utilities
    
    attr_reader :preconditions, :reference
  
    def initialize(entry, doc)
      @doc = doc
      @entry = entry
      @preconditions = @entry.xpath('./*/cda:precondition', HQMF::Document::NAMESPACES).collect do |precondition|
        Precondition.new(precondition, @doc)
      end
      reference_def = @entry.at_xpath('./*/cda:id', HQMF::Document::NAMESPACES)
      if reference_def
        @reference = Reference.new(reference_def)
      end
    end
    
    # Return true of this precondition represents a conjunction with nested preconditions
    # or false of this precondition is a reference to a data criteria
    def conjunction?
      @preconditions.length>0
    end
    
    # Get the conjunction code, e.g. allTrue, allFalse
    # @return [String] conjunction code
    def conjunction_code
      @entry.at_xpath('./*[1]', HQMF::Document::NAMESPACES).name
    end
    
  end
    
end