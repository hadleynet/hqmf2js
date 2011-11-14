module HQMF
  class Comparison
  
    include HQMF::Utilities
    
    attr_reader :restrictions, :data_criteria_id, :title
    
    def initialize(data_criteria_id, entry, parent)
      @data_criteria_id = data_criteria_id
      @entry = entry
      title_def = @entry.at_xpath('./*/cda:title')
      if title_def
        @title = title_def.inner_text
      end
      @restrictions = []
      if parent
        @restrictions.concat(parent.restrictions)
      end
      restriction_def = @entry.at_xpath('./*/cda:sourceOf')
      if restriction_def
        @restrictions << Restriction.new(restriction_def)
      end
    end
    
  end
end