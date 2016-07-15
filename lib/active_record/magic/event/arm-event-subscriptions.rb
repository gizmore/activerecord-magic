##
#
module ActiveRecord
  module Magic
    module Event
      class Subscriptions
        
        @@total_hooks = 0
        
        def self.total_hooks
          @@total_hooks;
        end

        def add(hook)
          @hooks ||= []
          @hooks.push(hook)
          @@total_hooks += 1
          self
        end
        
        def remove(hook)
          @hooks.delete(hook)
          @@total_hooks -= 1
          nil
        end

        def signal(source, event, args)
          @hooks.each do |hook|
            hook.signal(source, event, args)
          end
          self
        end
        
      end
    end
  end
end

