module ActiveRecord::Magic::Value

  module Extend

    @@arm_class_variables = {}
    
    def define_class_variable(varname, value)
      class_eval do |klass|
        varname = varname.to_sym
        register_class_variable(varname)
        instance_variable_defined?(varname) ? get_class_variable(varname) : set_class_variable(varname, value) 
      end
    end
  
    def set_class_variable(varname, value)
      instance_variable_set(varname.to_sym, value)
      value
    end

    def get_class_variable(varname, default=nil)
      instance_variable_get(varname.to_sym) || default
    end
   
    # def clear_class_variables
      # if instance_variable_defined?(:@plugin_vars)
        # vars = remove_instance_variable(:@plugin_vars)
        # vars.each do |var|
          # remove_instance_variable(var)
        # end
      # end
    # end

    def register_class_variable(varname)
      class_eval do |klass|
        varname = varname.to_sym
        vars = @@arm_class_variables[klass] ||= []
        unless vars.include?(varname)
          vars.push(varname)
          instance_variable_set(:@plugin_vars, vars)
        end
        nil
      end
    end
    
  end
  
  module Include

    def define_class_variable(varname, value)
      self.class.define_class_variable(varname, value)
    end

    def set_class_variable(varname, value)
      self.class.set_class_variable(varname, value)
    end

    def get_class_variable(varname, default=nil)
      self.class.get_class_variable(varname, default)
    end

  end

end

Object.extend ActiveRecord::Magic::Value::Extend
Object.send :include, ActiveRecord::Magic::Value::Include
