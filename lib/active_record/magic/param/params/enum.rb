module ActiveRecord::Magic
  class Param::Enum < Parameter
    
    def default_options; { enums: [] }; end
    
    def display_example; enum_options.join('|'); end
  
    def input_to_value(input)
      input = input.to_s
      invalid!(:err_unknown_enum) unless enum_options.include?(input)
      input
    end
    
    def value_to_input(enum)
      enum.to_s
    end
    
    def validate_enums_option!(value)
      invalid_config!(tt('ricer3.param.enum.err_invalid_enums')) unless value.is_a?(Array)
    end
    
    def enum_options
      option(:enums).map!{|enum|enum.to_s}
      option(:enums)
    end
  
  end
end
