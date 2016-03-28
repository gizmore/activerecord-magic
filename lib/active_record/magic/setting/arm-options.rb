module ActiveRecord
  module Magic
    module Options
      
      def self.merge(given, default, validate=true)
        if validate
          given.each do |key,value|
            raise ActiveRecord::Magic::UnknownOption.new(default, given, key) unless default.has_key?(key)
            raise ActiveRecord::Magic::InvalidOption.new(default, given, key) unless default[key].class == value.class
          end
        end
        given.reverse_merge!(default)
      end
      
      # module Extend
        # def arm_options(given, default, validate=true)
          # ActiveRecord::Magic::Options.merge(given, default, validate)
        # end
      # end
#       
      # module Include
        # def arm_options(given, default, validate=true)
          # ActiveRecord::Magic::Options.merge(given, default, validate)
        # end
      # end

    end
  end
end
