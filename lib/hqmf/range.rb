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
    
  end
end