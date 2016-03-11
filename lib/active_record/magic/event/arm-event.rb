##
# The ARM event system.
#
module ActiveRecord
  module Magic
    module Event
      
      load "active_record/magic/event/arm-event-container.rb"
      load "active_record/magic/event/arm-event-decorator.rb"
      load "active_record/magic/event/arm-event-extend.rb"
      load "active_record/magic/event/arm-event-hook.rb"
      load "active_record/magic/event/arm-event-subscriptions.rb"
      load "active_record/magic/event/arm-events.rb"
      load "active_record/magic/event/arm-every.rb"
      
      # The global event container.
      def self.globe
        ActiveRecord::Magic::Global.define('arm-global-event-container') { Globe.new }
      end
      
    end
  end
end

