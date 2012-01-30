module HQMF
  # Represents a data criteria specification
  class DataCriteria
  
    include HQMF::Utilities
    
    attr_reader :property, :type, :status
  
    # Create a new instance based on the supplied HQMF entry
    # @param [Nokogiri::XML::Element] entry the parsed HQMF entry
    def initialize(entry)
      @entry = entry
      @status = attr_val('./cda:observationCriteria/cda:statusCode/@code')
      @id_xpath = './cda:observationCriteria/cda:id/@extension'
      @code_list_xpath = './cda:observationCriteria/cda:code/@valueSet'
      
      entry_type = attr_val('./*/cda:definition/*/cda:id/@extension')
      case entry_type
      when 'Problem'
        @type = :diagnosis
        @code_list_xpath = './cda:observationCriteria/cda:value/@valueSet'
      when 'Encounter'
        @type = :encounter
      @id_xpath = './cda:encounterCriteria/cda:id/@extension'
      @code_list_xpath = './cda:encounterCriteria/cda:code/@valueSet'
      when 'LabResults'
        @type = :result
      when 'Procedure'
        @type = :procedure
      when 'Medication'
        @type = :medication
        @id_xpath = './cda:substanceAdministrationCriteria/cda:id/@extension'
        @code_list_xpath = './cda:substanceAdministrationCriteria/cda:participant/cda:roleParticipant/cda:code/@valueSet'
      when 'RX'
        @type = :medication
        @id_xpath = './cda:supplyCriteria/cda:id/@extension'
        @code_list_xpath = './cda:supplyCriteria/cda:participant/cda:roleParticipant/cda:code/@valueSet'
      when 'Demographics'
        @type = :characteristic
        @property = property_for_demographic
      when nil
        @type = :variable
      else
        raise "Unknown data criteria template identifier [#{entry_type}]"
      end
    end
    
    # Get the identifier of the criteria, used elsewhere within the document for referencing
    # @return [String] the identifier of this data criteria
    def id
      attr_val(@id_xpath)
    end
    
    # Get the title of the criteria, provides a human readable description
    # @return [String] the title of this data criteria
    def title
      @entry.at_xpath('./cda:localVariableName').inner_text
    end
    
    # Get the code list OID of the criteria, used as an index to the code list database
    # @return [String] the code list identifier of this data criteria
    def code_list_id
      attr_val(@code_list_xpath)
    end
    
    # Get a JS friendly constant name for this measure attribute
    def const_name
      components = title.gsub(/\W/,' ').split.collect {|word| word.strip.upcase }
      components.join '_'
    end
    
    private
    
    def property_for_demographic
      demographic_type = attr_val('./cda:observationCriteria/cda:code/@code')
      case demographic_type
      when '424144002'
        :age
      when '263495000'
        :gender
      else
        raise "Unknown demographic identifier [#{demographic_type}]"
      end
    end

  end
  
end