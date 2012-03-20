module Generator

  # Utility class used to supply a binding to Erb. Contains utility functions used
  # by the erb templates that are used to generate code.
  class ErbContext < OpenStruct
  
    # Create a new context
    # @param [Hash] vars a hash of parameter names (String) and values (Object).
    # Each entry is added as an accessor of the new Context
    def initialize(vars)
      super(vars)
    end
  
    # Get a binding that contains all the instance variables
    # @return [Binding]
    def get_binding
      binding
    end
    
    def js_for_value(value)
      if value
        if value.derived?
          value.expression
        else
          if value.type=='TS'
            "new TS(\"#{value.value}\")"
          elsif value.unit != nil
            "new #{value.type}(#{value.value}, \"#{value.unit}\")"
          else
            "new #{value.type}(\"#{value.value}\")"
          end
        end
      else
        'null'
      end
    end
    
    def js_for_bounds(bounds)
      if bounds.class == HQMF::Range
        "new IVL(#{js_for_value(bounds.low)}, #{js_for_value(bounds.high)})"
      else
        "#{js_for_value(bounds)}"
      end
    end
    
    # Returns the JavaScript generated for a HQMF::Precondition
    def js_for_precondition(precondition, indent)
      template_str = File.read(File.expand_path("../precondition.js.erb", __FILE__))
      template = ERB.new(template_str, nil, '-', "_templ#{TemplateCounter.instance.new_id}")
      params = {'doc' => doc, 'precondition' => precondition, 'indent' => indent}
      context = ErbContext.new(params)
      template.result(context.get_binding)
    end
  end

  # Entry point to JavaScript generator
  class JS
  
    def initialize(hqmf_file)
      @doc = HQMF::Document.new(hqmf_file)
    end
    
    # Generate JS for a HQMF::PopulationCriteria
    def js_for(criteria_code)
      template_str = File.read(File.expand_path("../population_criteria.js.erb", __FILE__))
      template = ERB.new(template_str, nil, '-', "_templ#{TemplateCounter.instance.new_id}")
      criteria = @doc.population_criteria(criteria_code)
      if criteria
        params = {'doc' => @doc, 'criteria' => criteria}
        context = ErbContext.new(params)
        template.result(context.get_binding)
      else
        ''
      end
    end
    
    # Generate JS for a HQMF::DataCriteria
    def js_for_data_criteria
      template_str = File.read(File.expand_path("../data_criteria.js.erb", __FILE__))
      template = ERB.new(template_str, nil, '-', "_templ#{TemplateCounter.instance.new_id}")
      params = {'all_criteria' => @doc.all_data_criteria}
      context = ErbContext.new(params)
      template.result(context.get_binding)
    end

  end

  # Simple class to issue monotonically increasing integer identifiers
  class Counter
    def initialize
      @count = 0
    end
    
    def new_id
      @count+=1
    end
  end
    
  # Singleton to keep a count of function identifiers
  class FunctionCounter < Counter
    include Singleton
  end
  
  # Singleton to keep a count of template identifiers
  class TemplateCounter < Counter
    include Singleton
  end
end