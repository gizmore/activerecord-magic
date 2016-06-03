class ActiveRecord::Magic::InvalidParameter < ActiveRecord::Magic::Exception; end
module ActiveRecord
  module Magic
    class Parameter
      
      attr_reader :options
      
      arm_i18n
      
      def self.from_setting_options(options)
        klass = ActiveRecord::Magic::Param.const_get(options[:type].to_s.camelize)
        klass.new.from_setting_options(options)
      end
      
      def default_options
        {}
      end
      
      def initialize
        @options = default_options;
        @value = nil
      end
      
      def from_setting_options(options)
        @options.merge!(options)
        @value = options[:default] 
        self
      end
      
      ##############
      ### Errors ###
      ##############
      def invalid!(key, args={})
        raise ActiveRecord::Magic::InvalidParameter.new(t(key, args))
      end
      
      ###############
      ### Options ###
      ###############
      def option(key)
        @options[key]
      end
      
      #############
      ### Named ###
      #############
      def display_type
        t!(:type) rescue default_name
      end
    
      def display_name
        return display_type if @options[:named].nil?
        t!("ricer3.param.#{option(:named)}.type") rescue option(:named)
      end
      
      def named
        @_named ||= (option(:named) || default_name)
      end
      
      def default_name
        self.class.name.rsubstr_from('::').downcase
      end

      #############
      ### Eater ###
      #############
      def eater?
        default_eater
      end
      
      def default_eater; false; end
      
      ################
      ### Examples ###
      ################
      def display_examples
        t("ricer3.param.examples", example: display_example)
      end
      
      def display_example
        t("ricer3.param.no_example")
      end
      
      
      #################
      ### Value API ###
      #################
      def db_value
        value_to_input(@value)
      end
      
      def get_value
        @value
      end
      
      def set_value(value)
        @value = value
      end
      
      def display_value
        value_to_input(@value)
      end
      
      ################
      ### Multiple ###
      ################
      def doing_multiple?
        @options[:multiple] # && (!own_multi_handler?)
      end

      ######################
      ### Convert In/Out ###
      ######################
      def input_to_value(input); input.to_s; end
      def value_to_input(value); value.to_s; end
      
      def values_to_input(values)
        if doing_multiple?
          inputs = Array(values).collect{|value| _value_to_input(value)}
          inputs.length > 1 ? "#{inputs.join(',')}" : inputs[0]
        else
          value_to_input(values)
        end
      end
      
      def input_to_values(inputs)
        if doing_multiple?
          inputs.split(',').collect{|input| _input_to_value(input) }
        else
          _input_to_value(inputs)
        end
      end
      
      def value_to_input!(value)
        values_to_input(value)
      end

      def input_to_value!(value)
        input_to_values(value)
      end
      
      def _input_to_value(input)
        value = input_to_value(input)
        validate!(value)
        invalid! unless value
        value
      end

      def _value_to_input(value)
        validate!(value)
        input = value_to_input(value)
        invalid! unless input
        input
      end

    end
  end
end

#####################
### Param Classes ###
#####################
module ActiveRecord::Magic::Param; end
Filewalker.proc_files(File.dirname(__FILE__)+"/params", '*.rb') do |file|
  load file
end
