##
#  
module ActiveRecord
  module Magic
    module Event
      class Container
        
        # attr_reader :subscriptions
        
        @@total_events = 0
        
        def self.total_events
          @@total_events
        end
        
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
          subscriptions[event] ||= new_subscriptions_for(event)
        end
        
        def new_subscriptions_for(event)
          @@total_events += 1
          ActiveRecord::Magic::Event::Subscriptions.new
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
        
        def signal(source, event, args)
          if @subscriptions && subscriptions.has_key?(event)
            subscriptions[event].signal(source, event, args)
          else
            bot.log.debug("Event::Container.signal => #{event}")
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
