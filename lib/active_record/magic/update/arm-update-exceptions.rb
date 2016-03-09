module ActiveRecord
  module Magic

    class MissingDependency < ActiveRecord::Magic::Exception
      
      def initialize(chain)
        @chain = chain
      end
      
      def to_s
        messages = []
        @chain.steps_to_run.each do |klass, steps|
          if !@chain.has_dependencies?(steps.next)
            messages.push("#{klass} depends on #{steps.next.dependencies.inspect}")
          end
        end
        messages.join("\n")
      end
        
    end
  end
end
