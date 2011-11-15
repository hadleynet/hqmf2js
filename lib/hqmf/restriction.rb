module HQMF
  # Represents a restriction on the allowable values of a data item
  class Restriction
  
    include HQMF::Utilities
    
    attr_reader :range
    
    def initialize(entry)
      @entry = entry
      range_def = @entry.at_xpath('./cda:pauseQuantity')
      if range_def
        @range = Range.new(range_def)
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
    
    # The subset code (e.g. FIRST, SECOND etc) if present
    def subset
      attr_val('./cda:subsetCode/@code')
    end
    
  end
end