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
      @preconditions = @entry.xpath('./*/cda:precondition').collect do |entry|
        Precondition.new(entry, @doc)
      end
    end
    
    # Get the id for the population criteria
    # @return [String] the id
    def id
      attr_val('./*/cda:id/@extension')
    end
    
  end
end