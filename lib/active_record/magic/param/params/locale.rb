module ActiveRecord::Magic
  class Param::Locale < Parameter
    
    def input_to_value(input)
      Ricer3::Locale.by_iso(input)
    end

    def value_to_input(locale)
      locale.iso rescue nil
    end

    def validate!(value)
      invalid_type! unless value.is_a?(Ricer3::Locale)
    end
    
  end
end
