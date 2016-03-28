load File.expand_path("../password.rb", __FILE__)
module ActiveRecord::Magic
  class Param::Pashword < Param::Password
    
    def default_options; { min: 4, max: 256 }; end
    
    def default_value; input_to_value(option(:default)); end
    def default_input_to_value(value); value; end
    
    def display_value; t(:censored); end
    
    def input_to_value(input)
      ActiveRecord::Magic::Password.new(input)
    end
    
    def value_to_input(password)
      password.to_s
    end

    def validate!(password)
      invalid_type! unless password.is_a?(ActiveRecord::Magic::Password)
      validate_range!(password.length)
    end
    
  end
end
