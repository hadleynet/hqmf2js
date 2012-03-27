module HQMF
  # Represents a bound within a HQMF pauseQuantity, has a value, a unit and an
  # inclusive/exclusive indicator
  class Value
    include HQMF::Utilities
    
    attr_reader :type, :unit, :value
    
    def initialize(entry, default_type='PQ')
      @entry = entry
      @type = attr_val('./@xsi:type') || default_type
      @unit = attr_val('./@unit')
      @value = attr_val('./@value')
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
        @entry.at_xpath('./cda:expression', HQMF::Document::NAMESPACES).inner_text
      end
    end
  end
  
  # Represents a HQMF physical quantity which can have low and high bounds
  class Range
    include HQMF::Utilities
    attr_reader :low, :high, :width
    
    def initialize(entry)
      @entry = entry
      if @entry
        @low = optional_value('./cda:low', default_bounds_type)
        @high = optional_value('./cda:high', default_bounds_type)
        @width = optional_value('./cda:width', 'PQ')
      end
    end
    
    def type
      attr_val('./@xsi:type')
    end
    
    private
    
    def optional_value(xpath, type)
      value_def = @entry.at_xpath(xpath, HQMF::Document::NAMESPACES)
      if value_def
        Value.new(value_def, type)
      else
        nil
      end
    end
    
    def default_bounds_type
      case type
      when 'IVL_TS'
        'TS'
      else
        'PQ'
      end
    end 
  end
  
  # Represents a HQMF effective time which is a specialization of a interval
  class EffectiveTime < Range
    def initialize(entry)
      super
    end
    
    def type
      'IVL_TS'
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
    
    def id
      attr_val('./@extension')
    end
  end
  
end