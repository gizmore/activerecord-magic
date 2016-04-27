module ActiveRecord
  module Magic
    class Locale < ActiveRecord::Base
      
      self.table_name = 'arm_locales'

      ARM_LOCALES ||= ['en', 'fam', 'bot', 'ibdes']

      arm_i18n
      arm_cache
      arm_named_cache(:iso)

      arm_install do |migration|
        migration.create_table(table_name) do |t|
          t.string :iso, :null => false, :limit => 16, :charset => :ascii, :collation => :ascii_bin
        end
      end
      
      arm_install do |migration|
        ARM_LOCALES.each{|iso| find_or_create_by!(:iso => iso) }
        I18n.available_locales.each{|iso| find_or_create_by!(:iso => iso) }
      end
      
      ####################
      ### Translatable ###
      ####################
      def to_label
        native_name rescue foreign_name(I18n.locale) rescue "[#{self.iso}]"
      end

      def native_name
        foreign_name(self.iso)
      end
      
      def foreign_name(locale)
        in_language(locale) { return t!(self.iso.to_sym) }
      end
      
    end
  end
end
