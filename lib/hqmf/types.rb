module HQMF
  # Represents a bound within a HQMF pauseQuantity, has a value, a unit and an
  # inclusive/exclusive indicator
  class Value
    include HQMF::Utilities
    
    def initialize(entry)
      @entry = entry
    end
    
    def type
      attr_val('./@xsi:type')
    end
    
    def value
      attr_val('./@value')
    end
    
    def unit
      attr_val('./@unit')
    end
    
    def inclusive?
      case attr_val('./@inclusive')
      when 'true'
        true
      else
        false
      end
    end
    
    def derived?
      case attr_val('./@nullFlavor')
      when 'DER'
        true
      else
        false
      end
    end
    
    def expression
      if !derived?
        nil
      else
        @entry.at_xpath('./cda:expression').inner_text
      end
    end
    
  end
  
  # Represents a HQMF pauseQuantity which can have low and high bounds
  class Range
    include HQMF::Utilities
    attr_reader :low, :high
    
    def initialize(entry)
      @entry = entry
      if @entry
        @low = optional_value('./cda:low')
        @high = optional_value('./cda:high')
      end
    end
    
    def type
      attr_val('./@xsi:type')
    end
    
    private
    
    def optional_value(xpath)
      value_def = @entry.at_xpath(xpath)
      if value_def
        Value.new(value_def)
      else
        nil
      end
    end 
  end
  
  # Represents a HQMF effective time which is a specialization of a interval
  class EffectiveTime < Range
    def initialize(entry)
      super
    end
    
    def type
      'IVL_PQ'
    end
  end
  
  # Represents a HQMF CD value which has a code and codeSystem
  class Coded
    include HQMF::Utilities
    
    def initialize(entry)
      @entry = entry
    end
    
    def type
      attr_val('./@xsi:type')
    end
    
    def system
      attr_val('./@codeSystem')
    end
    
    def code
      attr_val('./@code')
    end

    def value
      code
    end

    def derived?
      false
    end

    def unit
      nil
    end
  end
  
  # Represents a HQMF reference from a precondition to a data criteria
  class Reference
    include HQMF::Utilities
    
    def initialize(entry)
      @entry = entry
    end
    
    def data_criteria_id
      attr_val('./@extension')
    end
  end
  
end