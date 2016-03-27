module ActiveRecord
  module Magic
    class Permission < ActiveRecord::Base
      
      self.table_name = 'arm_permissions'

      arm_cache
      
      arm_install() do |migration|
        migration.create_table(table_name) do |t|
          t.string :name, :null => false, :limit => 64, :charset => :ascii, :collate => :ascii_bin, :unique => true
        end
      end

    end
  end
end