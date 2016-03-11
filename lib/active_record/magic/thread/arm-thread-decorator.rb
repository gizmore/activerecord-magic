module ActiveRecord
  module Magic

    module ThreadDecorator
      def arm_threads
        class_eval do |klass|
          arm_log.debug{"#{klass.name} is using arm_threads."}
          klass.send :include, ActiveRecord::Magic::ThreadExtend if !klass.is_a?(Module)
          klass.extend ActiveRecord::Magic::Event::ThreadExtend
        end
      end
    end

    module ThreadExtend
      def threaded(&block)
        regular_threaded(&block)
      end
      def regular_threaded(&block)
        
      end
      def worker_threaded(&block)
        
      end
      def service_threaded(&block)
        
      end
    end

  end
end

Object.extend ActiveRecord::Magic::ThreadDecorator
class Module; include ActiveRecord::Magic::ThreadDecorator; end
