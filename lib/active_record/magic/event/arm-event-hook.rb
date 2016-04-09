##
# A hook is a subscription to an event at a signal source container.
# 
#
module ActiveRecord
  module Magic
    module Event
      class Hook
        
        # statistic
        def self.total
          @@object_hooks.length + @@static_hooks.length
        end

        #
        def initialize(target, block, subscriptions)
          @target = target
          @block = block
          @subscriptions = subscriptions
          @lifetime, @hooked_at = nil
          @max_calls = nil
          @calls = 0
          @self_signal = true
          remember_me
        end
        
        def removed?
          @block == nil
        end
        
        def signal(source, event, args)
          arm_log.debug{"ARM::Event::Hook.signal(#{source.obj_id}-->#{event.upcase}-->#{@target.obj_id})"}
          expired = expired?
          if !self_signal_blocked?(source)
            remove if expired
            unless expired
              begin
                @block.call(source, args)
              rescue => e
                arm_log.exception(e)
              end
            end
            @calls += 1
            remove if exceeded?
          end
          nil
        end
        
        def remove
          @block = nil
          @subscriptions.remove(self)
          if is_static?
            @@static_hooks.delete(self)
          else
            @@object_hooks.delete(self)
          end
          nil
        end
        
        def self_signal(boolean=true)
          @self_signal = boolean
          self
        end
        
        def lifetime(seconds)
          @hooked_at ||= Time.now.to_f
          @lifetime = seconds
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
          @max_calls == nil ? false : @calls >= @max_calls
        end

        private
        
        def self_signal_blocked?(source)
          (source == @target) && (!@self_signal)
        end

        @@static_hooks ||= []
        @@object_hooks ||= []
        
        def remember_me
          if is_static?
            @@static_hooks.push(self)
          else
            @@object_hooks.push(self)
          end
        end
        
        def is_static?
          @target.class == Class || @target.class == Module
        end

      end
    end
  end
end

