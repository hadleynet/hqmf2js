module HQMF
  # Class representing an HQMF document
  class Document
    # Create a new HQMF::Document instance by parsing at file at the supplied path
    # @param [String] path the path to the HQMF document
    def initialize(path)
      @doc = Document.parse(path)
      @data_criteria = @doc.xpath('//cda:section[cda:code/@code="57025-9"]/cda:entry').collect do |entry|
        DataCriteria.new(entry)
      end
      @attributes = @doc.xpath('//cda:subjectOf/cda:measureAttribute').collect do |attr|
        Attribute.new(attr)
      end
      @population_criteria = @doc.xpath('//cda:section[cda:code/@code="57026-7"]/cda:entry').collect do |attr|
        PopulationCriteria.new(attr)
      end
    end
    
    # Get the title of the measure
    # @return [String] the title
    def title
      @doc.at_xpath('cda:QualityMeasureDocument/cda:title').inner_text
    end
    
    # Get the description of the measure
    # @return [String] the description
    def description
      @doc.at_xpath('cda:QualityMeasureDocument/cda:text').inner_text
    end
  
    # Get all the attributes defined by the measure
    # @return [Array] an array of HQMF::Attribute
    def all_attributes
      @attributes
    end
    
    # Get a specific attribute by id.
    # @param [String] id the attribute identifier
    # @return [HQMF::Attribute] the matching attribute, raises an Exception if not found
    def attribute(id)
      find(@attributes, :id, id)
    end
    
    # Get a specific attribute by code.
    # @param [String] code the attribute code
    # @return [HQMF::Attribute] the matching attribute, raises an Exception if not found
    def attribute_for_code(code)
      find(@attributes, :code, code)
    end

    # Get all the population criteria defined by the measure
    # @return [Array] an array of HQMF::PopulationCriteria
    def all_population_criteria
      @population_criteria
    end
    
    # Get a specific population criteria by id.
    # @param [String] id the population identifier
    # @return [HQMF::PopulationCriteria] the matching criteria, raises an Exception if not found
    def population_criteria(id)
      find(@population_criteria, :id, id)
    end
    
    # Get a specific population criteria by code.
    # @param [String] code the population criteria code
    # @return [HQMF::PopulationCriteria] the matching criteria, raises an Exception if not found
    def population_criteria_for_code(code)
      find(@population_criteria, :code, code)
    end

    # Get all the data criteria defined by the measure
    # @return [Array] an array of HQMF::DataCriteria describing the data elements used by the measure
    def all_data_criteria
      @data_criteria
    end
    
    # Get a specific data criteria by id.
    # @param [String] id the data criteria identifier
    # @return [HQMF::DataCriteria] the matching data criteria, raises an Exception if not found
    def data_criteria(id)
      find(@data_criteria, :id, id)
    end
    
    # Parse an XML document at the supplied path
    # @return [Nokogiri::XML::Document]
    def self.parse(path)
      doc = Nokogiri::XML(File.new(path))
      doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')
      doc
    end
    
    private
    
    def find(collection, attribute, value)
      collection.find {|e| e.send(attribute)==value}
    end
  end
end