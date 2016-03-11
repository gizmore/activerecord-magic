module ActiveRecord
  module Magic
    class Application
      
      arm_events
      
      attr_reader :config
      
      def initialize(config_path)
        @config = Config.new(config_path)
      end
      
      def config
        @config
      end
      
      def name
        @config.app_name
      end
      
      def run
        arm_log.info("#{name} started")
        
      end
      
    end
  end
end