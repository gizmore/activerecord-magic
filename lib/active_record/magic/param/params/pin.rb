load File.expand_path("../string.rb", __FILE__)
module ActiveRecord::Magic
  class Param::Pin < Param::String
    
    def default_options; { length: 8 }; end
    
    def min; options[:length]; end
    def max; options[:length]; end

    def self.random_pin(length=8)
      ActiveRecord::Magic::Pin.new(nil, length)
    end
    
    def display_value
      "'#{pin.display}'"
    end
    
    def input_to_value(input)
      ActiveRecord::Magic::Pin.new(input)
    end

    def value_to_input(pin)
      pin.display
    end

    def validate!(pin)
      invalid_type! unless pin.is_a?(Ricer3::Pin)
      validate_range!(pin.value.length)
    end
    
  end
end
