module HQMF
  class Comparison
  
    include HQMF::Utilities
    
    def initialize(data_criteria_id, entry)
      @data_criteria_id = data_criteria_id
      @entry = entry
      restriction_def = @entry.at_xpath('./*/cda:sourceOf')
      if restriction_def
        @restriction = Restriction.new(restriction_def)
      end
    end
    
    def data_criteria_id
      @data_criteria_id
    end
    
    def restriction
      @restriction
    end
    
  end
end