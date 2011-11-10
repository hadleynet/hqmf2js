module Generator

  # Utility class used to supply a binding to Erb
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
    
    def new_fn_name(prefix)
      "#{prefix}#{FunctionCounter.instance.new_id}"
    end
    
    def js_for_precondition(precondition, name)
      template_str = File.read(File.expand_path("../precondition.js.erb", __FILE__))
      template = ERB.new(template_str, nil, '-', "_templ#{TemplateCounter.instance.new_id}")
      params = {'doc' => doc, 'precondition' => precondition, 'name' => name}
      context = ErbContext.new(params)
      template.result(context.get_binding)
    end
    
    def js_for_comparison(comparison, name)
      template_str = File.read(File.expand_path("../comparison.js.erb", __FILE__))
      template = ERB.new(template_str, nil, '-', "_templ#{TemplateCounter.instance.new_id}")
      params = {'doc' => doc, 'comparison' => comparison, 'name' => name}
      context = ErbContext.new(params)
      template.result(context.get_binding)
    end

    def js_for_range(range)
      template_str = File.read(File.expand_path("../range.js.erb", __FILE__))
      template = ERB.new(template_str, nil, '-', "_templ#{TemplateCounter.instance.new_id}")
      params = {'range' => range}
      context = ErbContext.new(params)
      template.result(context.get_binding)
    end

    def js_for_value(value)
      template_str = File.read(File.expand_path("../value.js.erb", __FILE__))
      template = ERB.new(template_str, nil, '-', "_templ#{TemplateCounter.instance.new_id}")
      params = {'value' => value}
      context = ErbContext.new(params)
      template.result(context.get_binding)
    end
  end

  class JS
  
    def initialize(hqmf_file)
      @doc = HQMF::Document.new(hqmf_file)
    end
    
    def js_for(criteria_code)
      template_str = File.read(File.expand_path("../population_criteria.js.erb", __FILE__))
      template = ERB.new(template_str, nil, '-', "_templ#{TemplateCounter.instance.new_id}")
      params = {'doc' => @doc, 'criteria_code' => criteria_code}
      context = ErbContext.new(params)
      template.result(context.get_binding)
    end
    
    def js_for_data_criteria
      template_str = File.read(File.expand_path("../data_criteria.js.erb", __FILE__))
      template = ERB.new(template_str, nil, '-', "_templ#{TemplateCounter.instance.new_id}")
      params = {'all_criteria' => @doc.all_data_criteria}
      context = ErbContext.new(params)
      template.result(context.get_binding)
    end

    def js_for_attributes
      template_str = File.read(File.expand_path("../attributes.js.erb", __FILE__))
      template = ERB.new(template_str, nil, '-', "_templ#{TemplateCounter.instance.new_id}")
      params = {'all_attributes' => @doc.all_attributes}
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
    
    def reset
      @count = 0
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