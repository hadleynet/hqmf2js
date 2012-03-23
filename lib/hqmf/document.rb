module HQMF
  # Class representing an HQMF document
  class Document
    attr_reader :measure_period
  
    # Create a new HQMF::Document instance by parsing at file at the supplied path
    # @param [String] path the path to the HQMF document
    def initialize(hqmf_contents)
      @doc = Document.parse(hqmf_contents)
      measure_period_def = @doc.at_xpath('cda:QualityMeasureDocument/cda:controlVariable/cda:measurePeriod/cda:value')
      if measure_period_def
        @measure_period = EffectiveTime.new(measure_period_def)
      end
      @data_criteria = @doc.xpath('cda:QualityMeasureDocument/cda:component/cda:dataCriteriaSection/cda:entry').collect do |entry|
        DataCriteria.new(entry)
      end
      @population_criteria = @doc.xpath('cda:QualityMeasureDocument/cda:component/cda:populationCriteriaSection/cda:entry').collect do |attr|
        PopulationCriteria.new(attr, self)
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
      description = @doc.at_xpath('cda:QualityMeasureDocument/cda:text')
      description==nil ? '' : description.inner_text
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
    def self.parse(hqmf_contents)
      doc = Nokogiri::XML(hqmf_contents)
      doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')
      doc.root.add_namespace_definition('xsi', 'http://www.w3.org/2001/XMLSchema-instance')
      doc
    end
    
    private
    
    def find(collection, attribute, value)
      collection.find {|e| e.send(attribute)==value}
    end
  end
end