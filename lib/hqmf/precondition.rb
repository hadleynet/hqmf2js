module HQMF
  
  class Precondition
  
    include HQMF::Utilities
    
    attr_reader :restrictions, :comparison, :preconditions, :subset
  
    def initialize(entry, parent, doc)
      @doc = doc
      @entry = entry
      @restrictions = []
      if (parent)
        @restrictions.concat(parent.restrictions.select {|r| r.field==nil})
        @subset = parent.subset
      end
      local_restrictions = @entry.xpath('./*/cda:sourceOf[@typeCode!="PRCN" and @typeCode!="COMP"]').collect do |entry|
        Restriction.new(entry, self, @doc)
      end
      @restrictions.concat(local_restrictions)
      local_subset = attr_val('./cda:subsetCode/@code')
      if local_subset
        @subset = local_subset
      end
      @preconditions = @entry.xpath('./*/cda:sourceOf[@typeCode="PRCN"]').collect do |entry|
        Precondition.new(entry, self, @doc)
      end
      comparison_def = @entry.at_xpath('./*/cda:sourceOf[@typeCode="COMP"]')
      if comparison_def
        data_criteria_id = attr_val('./*/cda:id/@root')
        @comparison = Comparison.new(data_criteria_id, comparison_def, self, @doc)
      end
    end
    
    # Get the conjunction code, e.g. AND, OR
    # @return [String] conjunction code
    def conjunction
      attr_val('./cda:conjunctionCode/@code')
    end
    
    def negation
      if @entry.at_xpath('./cda:act[@actionNegationInd="true"]')
        true
      else
        false
      end
    end
    
  end
  
end