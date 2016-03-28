module ActiveRecord
  module Magic
    module Random
      module Decorate
        def arm_random
          class_eval do |klass|
            klass.extend ActiveRecord::Magic::Random::Extend
            klass.send :include, ActiveRecord::Magic::Random::Extend
          end
        end
      end
      module Extend
        
      end
    end
  end
end
Object.extend ActiveRecord::Magic::Random::Decorate