module HQMF
  
  class Precondition
  
    include HQMF::Utilities
  
    def initialize(entry)
      @entry = entry
      @preconditions = @entry.xpath('./*/cda:sourceOf[@typeCode="PRCN"]').collect do |entry|
        Precondition.new(entry)
      end
      comparison_def = @entry.xpath('./*/cda:sourceOf[@typeCode="COMP"]')
      if comparison_def
        data_criteria_id = attr_val('./*/cda:id/@root')
        @comparison = Comparison.new(data_criteria_id, comparison_def)
      end 
    end
    
    # Get the child preconditions for this precondition. Note that
    # preconditions may be nested to an arbitrary depth
    # @return [Array] the child preconditions as an Array of HQMF::Precondition
    def preconditions
      @preconditions
    end
    
    # Get the conjunction code, e.g. AND, OR
    # @return [String] conjunction code
    def conjunction
      attr_val('./cda:conjunctionCode/@code')
    end
    
    # Get the comparison
    # @return [HQMF::Comparison] the comparison
    def comparison
      @comparison
    end
  end
  
end