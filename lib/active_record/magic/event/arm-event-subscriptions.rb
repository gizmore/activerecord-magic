##
#
module ActiveRecord
  module Magic
    module Event
      class Subscriptions

        def add(hook)
          @hooks ||= []
          @hooks.push(hook)
          self
        end
        
        def remove(hook)
          @hooks.delete(hook)
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

