module HQMF

  class DataCriteria
    def initialize(entry)
      @entry = entry
      @code_list_xpath = 'cda:act/cda:sourceOf//cda:code/@code'
      case entry.at_xpath('cda:act/cda:templateId/@root').value
      when '2.16.840.1.113883.3.560.1.25'
        @type = :characteristic
      when '2.16.840.1.113883.3.560.1.4'
        @type = :encounter
      when '2.16.840.1.113883.3.560.1.6'
        @type = :procedure
      when '2.16.840.1.113883.3.560.1.14'
        @type = :medication
      else
        raise "Unknown data criteria template identifier [#{template_id}]"
      end
    end
    
    def id
      @entry.at_xpath('cda:act/cda:id/@root').value
    end
    
    def title
      @entry.at_xpath('.//cda:title').inner_text
    end
    
    def code_list_id
      @entry.at_xpath(@code_list_xpath).value
    end
    
    def type
      @type
    end
    
    def status
      @status
    end
  end
  
end