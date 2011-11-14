module HQMF
  
  class Precondition
  
    include HQMF::Utilities
    
    attr_reader :restrictions, :comparison, :preconditions
  
    def initialize(entry, parent)
      @entry = entry
      @restrictions = []
      if (parent)
        @restrictions.concat(parent.restrictions)
      end
      local_restrictions = @entry.xpath('./*/cda:sourceOf[@typeCode!="PRCN" and @typeCode!="COMP"]').collect do |entry|
        Restriction.new(entry)
      end
      @restrictions.concat(local_restrictions)
      @preconditions = @entry.xpath('./*/cda:sourceOf[@typeCode="PRCN"]').collect do |entry|
        Precondition.new(entry, self)
      end
      comparison_def = @entry.at_xpath('./*/cda:sourceOf[@typeCode="COMP"]')
      if comparison_def
        data_criteria_id = attr_val('./*/cda:id/@root')
        @comparison = Comparison.new(data_criteria_id, comparison_def, self)
      end
    end
    
    # Get the conjunction code, e.g. AND, OR
    # @return [String] conjunction code
    def conjunction
      attr_val('./cda:conjunctionCode/@code')
    end
    
  end
  
end