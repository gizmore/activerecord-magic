module ActiveRecord
  module Magic
    
    load "active_record/magic/permission/arm-pin.rb"
    load "active_record/magic/permission/arm-password.rb"
    load "active_record/magic/permission/arm-group.rb"
    load "active_record/magic/permission/arm-group-permission.rb"
    load "active_record/magic/permission/arm-permission.rb"
    load "active_record/magic/permission/arm-user.rb"
    load "active_record/magic/permission/arm-user-group.rb"
    
    module Permissions
      module Extend
        
        def arm_group(name, *permissions)
          group = ActiveRecord::Magic::Group.find_or_create_by(name: name)
          group.permissions = arm_permissions(permissions)
          group.save!
        end

        def arm_permissions(*names)
          permissions = []
          Array(names).each do |name|
            permissions.push(ActiveRecord::Magic::Permission.find_or_create_by(name: name))
          end
          permissions
        end
        
      end
    end
    
  end
end