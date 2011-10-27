module HQMF
  
  class Precondition
  
    include HQMF::Utilities
  
    def initialize(entry)
      @entry = entry
      @preconditions = @entry.xpath('./*/cda:sourceOf[@typeCode="PRCN"]').collect do |entry|
        Precondition.new(entry)
      end
    end
    
    # Get the child preconditions for this precondition. Note that
    # preconditions may be nested to an arbitrary depth
    # @return [Array] the child preconditions as an Array of HQMF::Precondition
    def preconditions
      @preconditions
    end
    
    def conjunction
      attr_val('./cda:conjunctionCode/@code')
    end
  end
  
end