module ActiveRecord
  module Magic
    module Events
      module Include
        def subscribe(event, &block)
        end
      end
      module Extend
        def subscribe(event, &block)
        end
      end
    end
    
    class Hook
    end

    class Every
    end
    
    class Event
      RELOAD ||= 'arm.reload'
      RELOADED ||= 'arm.reloaded'
    end
    
    
    
  end
end
class Object
end