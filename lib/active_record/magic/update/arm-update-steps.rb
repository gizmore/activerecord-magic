module ActiveRecord
  module Magic
    module Update
     class Steps

        attr_reader :klass

        def initialize(klass)
          @klass = klass
          @steps = []
          @step = 0
        end

        def step
          @step + 1
        end

        def db_version=(step)
          @step = step
        end
        
        def db_version
          @step
        end

        def completed?
          @step >= @steps.length
        end

        def next
          @steps[@step]
        end

        def next!
          ActiveRecord::Magic::Record.installed!(@klass)
          @step += 1
        end

        def add_step(step)
          @steps.push(step)
        end

        def completed
          @step += 1
        end

        def has_block?(block)
          @steps.each do |step|
            return true if step.has_block?(block)
          end
          false
        end

      end
    end
  end
end
