module HQMF
  class Restriction
  
    include HQMF::Utilities
    
    def initialize(entry)
      @entry = entry
    end
    
    def type
      attr_val('./@typeCode')
    end
    
    def target_id
      attr_val('./*/cda:id/@root')
    end
  
  end
end