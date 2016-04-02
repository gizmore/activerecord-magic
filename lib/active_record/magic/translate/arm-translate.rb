module ActiveRecord
  module Magic
    module Translate
      
      load "active_record/magic/translate/arm-translate-extend.rb"
      
      def self.init
        ActiveRecord::Magic::Translate.load_i18n_dir(ActiveRecord::Magic::COREDIR)
      end
      
      def self.load_i18n_dir(directory)
        Filewalker.traverse_dirs(directory, 'lang') do |filestub, dir|
          Filewalker.traverse_files(dir, '*.yml') do |file|
            #arm_log.debug("Loaded lang file: #{file}")
            I18n.load_path.push(file)
          end
        end
      end
      
      module Decorator
        def arm_i18n
          class_eval do |klass|
            klass.send :include, ActiveRecord::Magic::Translate::Extend
          end
        end
      end
      
    end
  end
end

Object.extend ActiveRecord::Magic::Translate::Decorator

ActiveRecord::Magic::Translate.init
