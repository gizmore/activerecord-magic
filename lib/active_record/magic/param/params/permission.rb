module ActiveRecord::Magic
  class Param::Permission < Parameter
    
    def input_to_value(label)
      Ricer3::Permission.by_name(label)
    end
    
    def value_to_input(permission)
      permission.to_label unless permission.nil?
    end

    def validate!(permission)
       invalid!(:err_unknown_permission) unless permission.is_a?(Ricer3::Permission)
    end
    
  end
end
