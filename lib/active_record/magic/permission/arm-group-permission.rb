module ActiveRecord
  module Magic
    class GroupPermission < ActiveRecord::Base
      
      self.table_name = 'arm_group_permissions'

      arm_install('ActiveRecord::Magic::Group' => 1, 'ActiveRecord::Magic::Permission' => 1) do |migration|
        migration.create_table(table_name) do |t|
          t.integer :group_id, :null => false
          t.integer :permission_id, :null => false
        end
      end
      
      belongs_to :group, :class_name => 'ActiveRecord::Magic::Group'
      belongs_to :permission, :class_name => 'ActiveRecord::Magic::Permission'

    end
  end
end