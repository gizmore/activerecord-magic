module ActiveRecord
  module Magic
    class Encoding < ActiveRecord::Base
      
      arm_cache
      arm_named_cache(:iso)
      
      self.table_name = 'arm_encodings'
      
      arm_install do |migration|
        migration.create_table(table_name) do |t|
          t.string :iso, :null => false, :limit => 32, :charset => :ascii, :collation => :ascii_bin
        end
      end
    
      arm_install do |migration|
        find_or_create_by!(:iso => 'UTF-8')
        ::Encoding.list.each{|encoding|find_or_create_by!(:iso => encoding.to_s)}
      end
      
    end 
  end
end
