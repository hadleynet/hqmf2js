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
    
    def js_for_precondition(precondition, count)
      template_str = File.read(File.expand_path("../precondition.js.erb", __FILE__))
      template = ERB.new(template_str, nil, '<>', "_templ#{@count}")
      params = {'doc' => doc, 'precondition' => precondition, 'count' => count}
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
      template = ERB.new(template_str, nil, '<>', "_#{criteria_code}")
      params = {'doc' => @doc, 'criteria_code' => criteria_code}
      context = ErbContext.new(params)
      template.result(context.get_binding)
    end
    
  end
end