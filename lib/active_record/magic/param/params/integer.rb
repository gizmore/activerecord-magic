module ActiveRecord::Magic
  class Param::Integer < Parameter
    
    def default_options; { min: nil, max: nil, default: 0 }; end
    
    def min; options[:min]; end
    def max; options[:max]; end

    def input_to_value(label); label.to_i; end

    def value_to_input(value); value.to_s; end

    def validate!(value)
      invalid_type! unless value.is_a?(::Integer)
      validate_range!(value)
    end
    
    def validate_range!(value)
      options = { min: min, max: max }
      range_invalid!(:err_too_small, options) if min && value < min
      range_invalid!(:err_too_large, options) if max && value > max
    end

    def range_invalid!(key, args)
      key = min == max ? :err_not_exactly : :err_not_between 
      invalid!(range_tkey(key), args)
    end
    
    def range_tkey(key)
      "ricer3.param.integer.#{key}"
    end
    
  end
end
