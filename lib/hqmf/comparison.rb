module HQMF
  class Comparison
  
    include HQMF::Utilities
    
    attr_reader :restrictions, :data_criteria_id, :title, :subset
    
    def initialize(data_criteria_id, entry, parent, doc)
      @doc = doc
      @data_criteria_id = data_criteria_id
      @entry = entry
      title_def = @entry.at_xpath('./*/cda:title')
      if title_def
        @title = title_def.inner_text
      end
      @restrictions = []
      if parent
        @restrictions.concat(parent.restrictions.select {|r| r.field==nil})
        @subset = parent.subset
      end
      restriction_def = @entry.at_xpath('./*/cda:sourceOf')
      if restriction_def
        @entry.xpath('./*/cda:sourceOf').each do |restriction|
          @restrictions << Restriction.new(restriction, self, @doc)
        end
      end
    end
    
  end
end