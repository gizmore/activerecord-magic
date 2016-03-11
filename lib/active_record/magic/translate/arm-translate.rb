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
      
      module Decorator
        def arm_i18n
          class_eval do |klass|
            klass.extend ActiveRecord::Magic::Translate::Extend
          end
        end
      end
      
      module Extend
        
        def t
          puts 11111111
        end
        
      end
      
      
      
    end
  end
end

Object.extend ActiveRecord::Magic::Translate::Decorator