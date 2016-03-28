load File.expand_path("../integer.rb", __FILE__)
module ActiveRecord::Magic
  class Param::Float < Param::Integer
    
    def input_to_value(input)
      input.to_f
    end

    def validate!(float)
      invalid_type! unless float.is_a?(Numeric)
      validate_range!(float)
    end
    
  end
end
