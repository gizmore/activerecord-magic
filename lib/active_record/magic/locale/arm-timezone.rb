module ActiveRecord
  module Magic
    class Timezone < ActiveRecord::Base
      
      self.table_name = 'arm_timezones'

      arm_cache
      arm_named_cache(:iso)
      
      arm_install do |migration|
        migration.create_table(table_name) do |t|
          t.string :iso, :null => false, :limit => 64, :charset => :ascii, :collation => :ascii_bin
        end
      end
  
      arm_install do |migration|
        find_or_create_by!(iso: 'Berlin')
        ActiveSupport::TimeZone.all.each{|tz| find_or_create_by!(iso: tz.name) }
      end
      
    end
  end
end
