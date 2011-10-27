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
      attr = @attributes.find {|c| c.id==id}
      if attr
        attr
      else
        raise "Attribute not found: #{id}"
      end
    end
    
    # Get a specific attribute by code.
    # @param [String] code the attribute code
    # @return [HQMF::Attribute] the matching attribute, raises an Exception if not found
    def attribute_for_code(code)
      attr = @attributes.find {|c| c.code==code}
      if attr
        attr
      else
        raise "Attribute not found: #{code}"
      end
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
      criteria = @data_criteria.find {|c| c.id==id}
      if criteria
        criteria
      else
        raise "Data criteria not found: #{id}"
      end
    end
    
    # Parse an XML document at the supplied path
    # @return [Nokogiri::XML::Document]
    def self.parse(path)
      doc = Nokogiri::XML(File.new(path))
      doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')
      doc
    end
  end
end