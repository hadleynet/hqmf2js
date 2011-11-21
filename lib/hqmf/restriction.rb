module HQMF
  # Represents a restriction on the allowable values of a data item
  class Restriction
  
    include HQMF::Utilities
    
    attr_reader :range, :comparison, :restrictions, :subset, :preconditions
    
    def initialize(entry, parent, doc)
      @doc = doc
      @entry = entry
      @restrictions = []
      range_def = @entry.at_xpath('./cda:pauseQuantity')
      if range_def
        @range = Range.new(range_def)
      end
      if parent
        @restrictions.concat(parent.restrictions.select {|r| r.field==nil})
      end
      @subset = attr_val('./cda:subsetCode/@code')
      
      comparison_def = @entry.at_xpath('./*/cda:sourceOf[@typeCode="COMP"]')
      if comparison_def
        data_criteria_id = attr_val('./*/cda:id/@root')
        @comparison = Comparison.new(data_criteria_id, comparison_def, self, @doc)
      end
      
      @preconditions = @entry.xpath('./*/cda:sourceOf[@typeCode="PRCN"]').collect do |entry|
        p = Precondition.new(entry, nil, @doc)
      end
    end
    
    # The type of restriction, e.g. SBS, SBE etc
    def type
      attr_val('./@typeCode')
    end
    
    # The id of the data criteria or measurement property that the value
    # will be compared against
    def target_id
      attr_val('./*/cda:id/@root')
    end
    
    def field
      attr_val('./cda:observation/cda:code/@displayName')
    end
    
    def value
      attr_val('./cda:observation/cda:value/@displayName')
    end

  end
end