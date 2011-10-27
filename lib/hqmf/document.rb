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
    end
  
    # Get the data criteria defined by the measure
    # @return [Array] an array of HQMF::DataCriteria describing the data elements used by the measure
    def all_data_criteria
      @data_criteria
    end
    
    def data_criteria(id)
      @data_criteria.find {|c| c.id==id}
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