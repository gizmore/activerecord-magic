class ActiveRecord::Magic::InvalidParameter < StandardError; end
module ActiveRecord
  module Magic
    module Param; end
    class Parameter
      
      arm_i18n
      
      # Load core parameter classes
      Filewalker.traverse_files(File.dirname(__FILE__)+"/params") do |file|
        load file
      end
      
      def self.from_setting_options(options)
        ActiveRecord::Magic::Param::Boolean.new.from_setting_options(options)
      end
      
      def initialize
        @value = nil;
        
      end
      
      def invalid!(key)
        raise ActiveRecord::Magic::InvalidParameter.new(self)
      end
      
      def from_setting_options(options)
        @options = options
        @value = options[:default] 
        self
      end
      
      def set_value(value)
        @value = value
      end
      
      def get_value
        @value
      end
      
      def db_value
        value_to_input(@value)
      end
      
    end
  end
end