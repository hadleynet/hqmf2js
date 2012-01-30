module HQMF
  
  class Precondition
  
    include HQMF::Utilities
    
    attr_reader :preconditions
  
    def initialize(entry, doc)
      @doc = doc
      @entry = entry
      @preconditions = @entry.xpath('./*/cda:precondition').collect do |entry|
        Precondition.new(entry, @doc)
      end
    end
    
    def conjunction?
      @preconditions.length>0
    end
    
    # Get the conjunction code, e.g. allTrue, allFalse
    # @return [String] conjunction code
    def conjunction_code
      @entry.at_xpath('./*[1]').name
    end
    
  end
    
end