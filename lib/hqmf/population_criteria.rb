module HQMF
  # Represents an HQMF population criteria
  class PopulationCriteria
  
    include HQMF::Utilities
    
    attr_reader :preconditions
    
    # Create a new population criteria from the supplied HQMF entry
    # @param [Nokogiri::XML::Element] the HQMF entry
    def initialize(entry, doc)
      @doc = doc
      @entry = entry
      @preconditions = @entry.xpath('./*/cda:sourceOf[@typeCode="PRCN"]').collect do |entry|
        pc = Precondition.new(entry, nil, @doc)
        if pc.preconditions.length==0 && !pc.comparison && pc.restrictions.length==0
          nil
        else
          pc
        end
      end.compact
    end
    
    # Get the code for the population criteria
    # @return [String] the code (e.g. IPP, DEMON, NUMER, EXCL)
    def code
      value = attr_val('cda:observation/cda:value/@code')
      # exclusion population criteria has id of DENOM with actionNegationInd of true
      # special case this to simply handling
      if attr_val('cda:observation/@actionNegationInd')=='true'
        value = 'EXCL'
      end
      value
    end
    
    # Get the id for the population criteria, used elsewhere in the HQMF document to
    # refer to this criteria
    # @return [String] the id
    def id
      attr_val('cda:observation/cda:id/@root')
    end
    
  end
end