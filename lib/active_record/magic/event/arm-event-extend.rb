##
# 
module ActiveRecord
  module Magic
    module Event
      module Extend

        # global event container
        def arm_globe
          ActiveRecord::Magic::Event.globe
        end

        # this objects event container
        def arm_container
          @container ||= ActiveRecord::Magic::Event::Container.new
        end

        # link to another objects container
        def arm_link(target)
          @container = target.arm_container.merge(@container)
          self
        end

        # subscribe to an event and target.
        def arm_subscribe(event, target=nil, &block)
          raise ActiveRecord::Magic::InvalidCode.new("arm_subscribe requires a block given") unless block_given?
#          raise ActiveRecord::Magic::DuplicateEvent.new(self, event, block.source_location.join(' ')) 
          unless ActiveRecord::Magic::Block.duplicate?(self, block)
            target ||= arm_globe
            arm_log.debug{"ARM::Event::arm_subscribe '#{event.upcase}' for #{target.obj_id} at #{block.short_location}"}
            container = target.arm_container
            container.subscribe(event, self, block)
          end
        end
        
        # send an event to globe
        def arm_publish(event, *args)
          arm_globe.signal(self, event, args)
          self
        end
        
        # send an event to a container
        def arm_signal(target, event, *args)
          target.arm_container.signal(self, event, args)
          arm_publish(event, *args)
          self
        end

        # emit an event to local subscriptions
        def arm_emit(event, *args)
          return self if @container.nil? || @container.empty?
          @container.signal(self, event, args)
          self
        end
        
        def arm_every(seconds, up_to=nil, &block)
          ActiveRecord::Magic::Event::Every.repeat(seconds, up_to, block)
        end

      end
    end
  end
end
