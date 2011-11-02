module HQMF
  class Comparison
  
    include HQMF::Utilities
    
    attr_reader :restriction, :data_criteria_id
    
    def initialize(data_criteria_id, entry)
      @data_criteria_id = data_criteria_id
      @entry = entry
      restriction_def = @entry.at_xpath('./*/cda:sourceOf')
      if restriction_def
        @restriction = Restriction.new(restriction_def)
      end
    end
    
  end
end