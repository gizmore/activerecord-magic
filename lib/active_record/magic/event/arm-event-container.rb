##
#  
module ActiveRecord
  module Magic
    module Event
      class Container
        
        # attr_reader :subscriptions
        
        def arm_container
          self
        end
        
        def empty?
          @subscriptions.nil? || @subscriptions.empty?
        end
        
        def subscriptions
          @subscriptions ||= {}
        end
        
        def subscriptions_for(event)
          subscriptions[event] ||= ActiveRecord::Magic::Event::Subscriptions.new
        end
        
        def merge(container)
          unless container.nil?
            container.subscriptions.each do |event,subscriptions|
              subscriptions_for(event).merge(subscriptions)
            end
          end
          self
        end
        
        def subscribe(event, target, block)
          subscriptions = subscriptions_for(event)
          hook = ActiveRecord::Magic::Event::Hook.new(target, block, subscriptions)
          subscriptions.add(hook)
          hook
        end
        
        def signal(event, args)
          unless @subscriptions.nil? || (!subscriptions.has_key?(event))
            subscriptions[event].signal(self, event, args)
          end
          self
        end
        
      end
    end
  end
end

module ActiveRecord::Magic::Event
  class Globe < Container
  end
end
