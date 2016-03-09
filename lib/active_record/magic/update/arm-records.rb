### Similiar to Rails migrations table.
### The approach is to save classnames and their version.
module ActiveRecord::Magic
  class Record < ActiveRecord::Base
    
    self.table_name = "arm_records"
    
    def self.arm_record_install_v1
      return true if ActiveRecord::Base.connection.table_exists?(table_name)
      m = ActiveRecord::Migration.new
      m.create_table table_name do |t|
        t.string  :name,    :limit => 256,:null => false, :charset => :ascii, :collation => :ascii_bin
        t.integer :version, :length => 2, :default => 0, :unsigned => true
        t.timestamps :null => false
      end
    end
    
    def self.installed(klass)
      ActiveRecord::Magic::Record.find_or_create_by(:name => klass)
    end

    def self.installed!(klass)
      installed = self.installed(klass)
      installed.version += 1
      installed.save!
      arm_log.info("ActiveRecord::Magic::Record.installed!(#{klass})")
    end
    
  end
end