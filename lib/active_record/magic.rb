load "active_record/magic/version.rb"

module ActiveRecord
  module Magic
    
    load "active_record/magic/base/arm-base.rb"
    load "active_record/magic/thread/arm-threads.rb"    
    load "active_record/magic/log/arm-log.rb"
    load "active_record/magic/mail/arm-mail.rb"
    load "active_record/magic/setting/arm-globals.rb"
    load "active_record/magic/event/arm-event.rb"
    load "active_record/magic/config/arm-config.rb"
    load "active_record/magic/translate/arm-translate.rb"
    load "active_record/magic/cache/arm-cache.rb"
    load "active_record/magic/update/arm-update.rb"
    load "active_record/magic/setting/arm-setting.rb"
    load "active_record/magic/setting/arm-options.rb"
    
  end
end
