module ActiveRecord
  module Magic
    class User < ActiveRecord::Base
      
      self.table_name = 'arm_users'
      
      arm_install('ActiveRecord::Magic::Group' => 1) do |migration|
        migration.create_table(table_name) do |t|
          t.string :username, :limit => 64, :null => false
          t.string :email,    :limit => 96, :null => false
          t.timestamps :null => false
        end
      end
      
      has_many :user_groups, :class_name => 'ActiveRecord::Magic::UserGroup'
      has_many :groups,      :class_name => 'ActiveRecord::Magic::Group', :through => :user_groups
      has_many :permissions, :class_name => 'ActiveRecord::Magic::Permission', :through => :groups
      
    end
  end
end