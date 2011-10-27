module HQMF
  # Represents a HQMF measure attribute
  class Attribute
    # Create a new instance based on the supplied HQMF
    # @param [Nokogiri::XML::Element] attr the measure attribute element
    def initialize(attr)
      @attr = attr
    end

    # Get the attribute code
    # @return [String] the code
    def code
      @attr.at_xpath('./cda:code/@code').value
    end

    # Get the attribute name
    # @return [String] the name
    def name
      @attr.at_xpath('./cda:code/@displayName').value
    end
    
    # Get the attribute id, used elsewhere in the document to refer to the attribute
    # @return [String] the id
    def id
      attr_val('./cda:id/@root')
    end
    
    # Get the attribute value
    # @return [String] the value
    def value
      val = attr_val('./cda:value/@value')
      if val
        val
      else
        @attr.at_xpath('./cda:value').inner_text
      end
    end
    
    # Get the unit of the attribute value or nil if none is defined
    # @return [String] the unit
    def unit
      attr_val('./cda:value/@unit')
    end
    
    private
    
    # Utility function to handle optional attributes
    # @param xpath an XPath that identifies an XML attribute
    # @return the value of the attribute or nil if the attribute is missing
    def attr_val(xpath)
      attr = @attr.at_xpath(xpath)
      if attr
        attr.value
      else
        nil
      end
    end
      
  end
end