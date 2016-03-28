module ActiveRecord
  module Magic
    class Group < ActiveRecord::Base
      
      self.table_name = 'arm_groups'

      arm_cache
      arm_named_cache(:name)

      arm_install('ActiveRecord::Magic::Permission' => 1) do |migration|
        migration.create_table(table_name) do |t|
          t.string :name, :null => false, :limit => 64, :charset => :ascii, :collate => :ascii_bin, :unique => true
        end
      end

      has_many :group_permissions, :class_name => 'ActiveRecord::Magic::GroupPermission'
      has_many :permissions, :class_name => 'ActiveRecord::Magic::Permission', :through => :group_permissions

    end
  end
end