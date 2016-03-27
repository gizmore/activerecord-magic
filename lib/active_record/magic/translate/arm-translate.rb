module ActiveRecord
  module Magic
    module Translate
      
      arm_events
      
      @directories = []
      
      def self.add_directory(directory)
        @directories.push(directory)
      end
      
      arm_subscribe(ActiveRecord::Magic::Event::INIT) do
        
      end
      
      module Extend
        
        def t(key)
          key.to_s
        end
        
      end
      
      module Decorator
        def arm_i18n
          class_eval do |klass|
            klass.send :include, ActiveRecord::Magic::Translate::Extend
          end
        end
      end
      
    end
  end
end

Object.extend ActiveRecord::Magic::Translate::Decorator