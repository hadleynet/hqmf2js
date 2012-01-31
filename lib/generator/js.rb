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
        "{\"low\": #{js_for_value(bounds.low)}, \"high\": #{js_for_value(bounds.high)}}"
      else
        "#{js_for_value(bounds)}"
      end
    end
    
#     # Create a new function name using the supplied prefix and an incremented counter.
#     def new_fn_name(prefix)
#       "#{prefix}#{FunctionCounter.instance.new_id}"
#     end
#     
#     # Returns the JavaScript generated for a HQMF::Precondition
#     def js_for_precondition(precondition, name)
#       template_str = File.read(File.expand_path("../precondition.js.erb", __FILE__))
#       template = ERB.new(template_str, nil, '-', "_templ#{TemplateCounter.instance.new_id}")
#       params = {'doc' => doc, 'precondition' => precondition, 'name' => name}
#       context = ErbContext.new(params)
#       template.result(context.get_binding)
#     end
#     
#     # Returns the JavaScript generated for a HQMF::Comparison
#     def js_for_comparison(comparison, name)
#       template_str = File.read(File.expand_path("../comparison.js.erb", __FILE__))
#       template = ERB.new(template_str, nil, '-', "_templ#{TemplateCounter.instance.new_id}")
#       params = {'doc' => doc, 'comparison' => comparison, 'name' => name}
#       context = ErbContext.new(params)
#       template.result(context.get_binding)
#     end
# 
#     # Returns the JavaScript generated for a HQMF::Restriction
#     def js_for_restriction(restriction, name)
#       template_str = File.read(File.expand_path("../restriction.js.erb", __FILE__))
#       template = ERB.new(template_str, nil, '-', "_templ#{TemplateCounter.instance.new_id}")
#       params = {'doc' => doc, 'restriction' => restriction, 'name' => name}
#       context = ErbContext.new(params)
#       template.result(context.get_binding)
#     end
# 
#     # Returns the JavaScript generated for a HQMF::Range
#     def js_for_range(range)
#       template_str = File.read(File.expand_path("../range.js.erb", __FILE__))
#       template = ERB.new(template_str, nil, '-', "_templ#{TemplateCounter.instance.new_id}")
#       params = {'range' => range}
#       context = ErbContext.new(params)
#       template.result(context.get_binding)
#     end
# 
#     # Returns the JavaScript generated for a HQMF::Value
#     def js_for_value(value)
#       template_str = File.read(File.expand_path("../value.js.erb", __FILE__))
#       template = ERB.new(template_str, nil, '-', "_templ#{TemplateCounter.instance.new_id}")
#       params = {'value' => value}
#       context = ErbContext.new(params)
#       template.result(context.get_binding)
#     end
#     
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
      params = {'doc' => @doc, 'criteria_code' => criteria_code}
      context = ErbContext.new(params)
      template.result(context.get_binding)
    end
    
    # Generate JS for a HQMF::DataCriteria
    def js_for_data_criteria
      template_str = File.read(File.expand_path("../data_criteria.js.erb", __FILE__))
      template = ERB.new(template_str, nil, '-', "_templ#{TemplateCounter.instance.new_id}")
      params = {'all_criteria' => @doc.all_data_criteria}
      context = ErbContext.new(params)
      template.result(context.get_binding)
    end

    # Generate JS for a HQMF::Attribute
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