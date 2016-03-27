module ActiveRecord
  module Magic
    module Options
      
      def self.merge(default, given, validate=true)
        if validate
          given.each do |key,value|
            raise ActiveRecord::Magic::UnknownOption.new(default, given, key) unless default.has_key?(key)
            raise ActiveRecord::Magic::InvalidOption.new(default, given, key) unless default[key].class == value.class
          end
        end
        given.reverse_merge(default)
      end
      
      module Extend
        def arm_options(default, given, validate=true)
          ActiveRecord::Magic::Options.merge(default, given, validate)
        end
      end
      
      module Include
        def arm_options(default, given, validate=true)
          ActiveRecord::Magic::Options.merge(default, given, validate)
        end
      end

    end
  end
end
