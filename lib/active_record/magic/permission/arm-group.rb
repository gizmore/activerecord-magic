module ActiveRecord
  module Magic
    class Group < ActiveRecord::Base
      
      self.table_name = 'arm_groups'

      arm_cache

      arm_install('ActiveRecord::Magic::Permission' => 1) do |migration|
        migration.create_table(table_name) do |t|
          t.string :name, :null => false, :limit => 64, :charset => :ascii, :collate => :ascii_bin, :unique => true
        end
      end

      has_many :permissions, :class_name => 'ActiveRecord::Magic::Permission', :through => :groups

    end
  end
end