module HQMF
  
  class Precondition
  
    include HQMF::Utilities
    
    attr_reader :restrictions, :comparison, :preconditions
  
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
      @restrictions = @entry.xpath('./*/cda:sourceOf[@typeCode!="PRCN" and @typeCode!="COMP"]').collect do |entry|
        Restriction.new(entry)
      end
    end
    
    # Get the conjunction code, e.g. AND, OR
    # @return [String] conjunction code
    def conjunction
      attr_val('./cda:conjunctionCode/@code')
    end
    
  end
  
end