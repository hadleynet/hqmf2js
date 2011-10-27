module HQMF
  class Comparison
  
    include HQMF::Utilities
    
    def initialize(data_criteria_id, entry)
      @data_criteria_id = data_criteria_id
      @entry = entry
    end
    
    def data_criteria_id
      @data_criteria_id
    end
    
    def restriction
      attr_val('./*/cda:sourceOf/@typeCode')
    end
    
  end
end