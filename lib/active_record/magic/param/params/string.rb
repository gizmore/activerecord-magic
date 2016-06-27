load File.expand_path("../integer.rb", __FILE__)
module ActiveRecord::Magic
  class Param::String < Param::Integer
    
    def default_options; { min: 0, max: nil, pattern: nil, default: nil }; end

    def display_value; "'#{value}'"; end

    def input_to_value(input); input.to_s; end

    def value_to_input(value); value ? value.to_s : nil; end
    
    def validate!(value)
      invalid_type! unless value.is_a?(::String)
      validate_pattern!(value) if options[:pattern]
      validate_range!(value.length)
    end

    def range_tkey(key)
      "ricer3.param.string.#{key}"
    end
    
    def validate_pattern!(value)
      unless Regexp.new(options[:pattern]).match(value)
        invalid!(:err_invalid_pattern)
      end
    end
    
  end
end
