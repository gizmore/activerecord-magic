module ActiveRecord
  module Magic
    class Locale < ActiveRecord::Base
      
      ARM_LOCALES ||= ['en', 'fam', 'bot', 'ibdes']

      arm_cache
      arm_named_cache(:iso)

      self.table_name = 'arm_locales'
      
      arm_install do |migration|
        migration.create_table(table_name) do |t|
          t.string :iso, :null => false, :limit => 16, :charset => :ascii, :collation => :ascii_bin
        end
      end
      
      arm_install do |migration|
        ARM_LOCALES.each{|iso| find_or_create_by!(:iso => iso) }
        I18n.available_locales.each{|iso| find_or_create_by!(:iso => iso) }
      end

    end
  end
end
