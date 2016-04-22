##
# on the fly config variable decleration and usage.
#
module ActiveRecord
  module Magic
    class Config
      
      require 'yaml'
      
      attr_reader :path
      
      def initialize(path)
        arm_init_config(path)
      end
      
      def valid?
        File.exists?(@path) && File.file?(@path) && File.writable?(@path)
      end
    
      def get(key, default)
        arm_get(key, default)
      end
      
      def method_missing(name, *args)
        name = name.to_s
        name.end_with?('=') ? arm_set(name[0...-1], args[0]) : arm_get(name, *args)
      end
      
      private
      
      def arm_init_config(path)
        begin
          @path = path
          @store = YAML.load_file(path)
        rescue Errno::ENOENT => e
          @store = {}
          arm_set(:app_name, 'Application Foobar')
          arm_set(:app_shortname, 'Application')
          arm_set(:arm_version, ::ActiveRecord::Magic::VERSION)
          arm_set(:environment, 'DEV/PROD')
        end
        self
      end
      
      def arm_get(key, default=nil)
        key = key.to_sym
        return @store[key] if @store.include?(key)
        @store[key] = default
        arm_save_config
        default
      end
      
      def arm_set(key, value)
        key = key.to_sym
        if (!@store.include?(key)) || (@store[key] != value)
          @store[key] = value
          arm_save_config
        end
        self
      end
      
      def arm_save_config
        File.open(@path, 'w') do |file|
          file.write(@store.to_yaml)
        end
        self
      end
      
    end
  end
end