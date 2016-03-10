# The ARM event system is.... phew
module ActiveRecord
  module Magic
    module Event
      
      load "active_record/magic/event/arm-every.rb"
      load "active_record/magic/event/arm-events.rb"

      class Hook
        def initialize(event, &block)
        end
      end
      
      class Hooks
        def initialize
        end
      end
      
      class Signal
        def initialize
        end
      end
      
      class Container
        def initialize(events, objects)
          @events = Array(events)
        end
      end
      
      module Decorator
        def arm_events
          class_eval do |klass|
            arm_log.debug("#{klass.name} is using arm_events.")
            klass.send :include, ActiveRecord::Magic::Event::Include
            klass.extend ActiveRecord::Magic::Event::Extend
          end
        end
      end
      
      module Extend
        def arm_link()
        end
        def arm_emit(event, *args)
        end
        def arm_publish(event, *args)
        end
        def arm_subscribe(event, &block)
        end
      end

      module Include
      end
      
    end
  end
end
Object.extend ActiveRecord::Magic::Event::Decorator
