module ActiveRecord
  module Magic
    module Setting
      
      load "active_record/magic/setting/arm-setting-entry.rb"
      load "active_record/magic/setting/arm-setting-exceptions.rb"
      load "active_record/magic/setting/arm-setting-extend.rb"

      module Decorator
        def arm_settings
          class_eval do |klass|
            klass.extend ActiveRecord::Magic::Setting::Extend
            klass.send(:include, ActiveRecord::Magic::Setting::Include)
          end
        end
      end

    end
  end
end

ActiveRecord::Base.extend ActiveRecord::Magic::Setting::Decorator