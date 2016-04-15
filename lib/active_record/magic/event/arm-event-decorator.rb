##
# Add decorators to Module and Object.
# Enable the arm event system by calling arm_events in the class.
# 
module ActiveRecord
  module Magic
    module Event
      module Decorator
        def arm_events
          class_eval do |klass|
#            arm_log.debug{"ARM::Event::arm_events enabled for #{klass.short_name}"}
            klass.send :include, ActiveRecord::Magic::Event::Extend if klass.class == Class
            klass.extend ActiveRecord::Magic::Event::Extend
          end
        end
      end
    end
  end
end
##
# add the decorator. 
class Module; include ActiveRecord::Magic::Event::Decorator; end
Object.extend ActiveRecord::Magic::Event::Decorator
