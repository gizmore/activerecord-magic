##
# A hook is a subscription to an event at a signal source container.
#
module ActiveRecord
  module Magic
    module Event
      class Hook

        def initialize(target, block, subscriptions)
          @target = target
          @block = block
          @subscriptions = subscriptions
          @lifetime = nil
          @hooked_at = nil
          @max_calls = nil
        end
        
        def signal(source, event, args)
          arm_log.debug{"ARM::Event::Hook.signal(#{source}-->#{event}-->#{@target})"}
          expired = expired?
          remove if expired || exceeded?
          @block.call(source, args) unless expired
          nil
        end
        
        def remove
          @subscriptions.remove(self)
          nil
        end
        
        def lifetime(seconds)
          @hooked_at ||= Time.now.to_f
          lifetime = seconds
          self
        end
        
        def max_calls(calls)
          @max_calls = calls
          self
        end
        
        def age
          Time.now.to_f - @hooked_at
        end
        
        def expired?
          @lifetime == nil ? false : age >= @lifetime
        end
        
        def exceeded?
          @max_calls == nil ? false : @max_calls <= 0
        end

      end
    end
  end
end

