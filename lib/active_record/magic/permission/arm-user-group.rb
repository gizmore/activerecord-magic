module ActiveRecord
  module Magic
    class UserGroup < ActiveRecord::Base
      
      self.table_name = 'arm_user_groups'
      
      arm_install('ActiveRecord::Magic::User' => 1, 'ActiveRecord::Magic::Group' => 1) do |migration|
        migration.create_table(table_name) do |t|
          t.references :user
          t.references :group
        end
      end

      belongs_to :user,  :class_name => 'ActiveRecord::Magic::User'
      belongs_to :group, :class_name => 'ActiveRecord::Magic::Group'
      
    end
  end
end