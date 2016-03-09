module ActiveRecord
  module Magic
    module Options
      
      def self.merge(default, given, validate=true)
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
