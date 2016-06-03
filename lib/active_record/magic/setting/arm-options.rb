# Module
# ActiveRecord::Magic::Options
#
# Merge options and roughly validate them.
#
module ActiveRecord
  module Magic
    module Options
      
      def self.merge(given, default, validate=true)
        if validate
          given.each do |key,value|
            raise ActiveRecord::Magic::UnknownOption.new(default, given, key) unless default.has_key?(key)
            raise ActiveRecord::Magic::InvalidOption.new(default[key], value, key) unless self.option_class_matches?(default[key], value)
          end
        end
        given.reverse_merge!(default)
      end
      
      private
      
      def self.option_class_matches?(a, b)
        (a == nil) || (b == nil) || ((a == true || a == false) && (b == true || b == false)) || (self.class_matches?(a, b))
      end
      
      def self.class_matches?(a, b)
        ((a.class.ancestors & b.class.ancestors).grep(Class) - [Object, BasicObject]).any?
      end

    end
  end
end
