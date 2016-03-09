require "active_record/magic/version"

module ActiveRecord
  module Magic
    
    load "active_record/magic/log/arm-log.rb"
    load "active_record/magic/base/arm-base.rb"
    load "active_record/magic/event/arm-events.rb"
    load "active_record/magic/variable/arm-variable.rb"
    load "active_record/magic/config/arm-config.rb"
    load "active_record/magic/cache/arm-cache.rb"
    load "active_record/magic/update/arm-update.rb"
#    load "active_record/magic/reload/arm-reload.rb"
    
  end

end
