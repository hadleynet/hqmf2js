module HQMF
  # Represents an HQMF population criteria, also supports all the same methods as
  # HQMF::Precondition
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
    
    # Return true of this precondition represents a conjunction with nested preconditions
    # or false of this precondition is a reference to a data criteria
    def conjunction?
      true
    end

    # Get the conjunction code, e.g. allTrue, allFalse
    # @return [String] conjunction code
    def conjunction_code
      case id
      when 'IPP', 'DENOM', 'NUMER'
        'allTrue'
      when 'DENEXCEP'
        'atLeastOneTrue'
      else
        raise "Unknown population type [#{id}]"
      end
    end

  end
  
end