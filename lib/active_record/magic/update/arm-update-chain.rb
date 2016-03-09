module ActiveRecord
  module Magic
    module Update
      class Chain

        attr_reader :total

        def initialize
          @chain = {}
          @total = 0
        end

        def add_step(klass, dependencies, block)
          if @chain.has_key?(klass)
            steps = @chain[klass]
          else
            @chain[klass] = steps = ActiveRecord::Magic::Update::Steps.new(klass)
          end
          return if steps.has_block?(block)
          step = ActiveRecord::Magic::Update::Step.new(dependencies, block)
          steps.add_step(step)
        end

        def runs_left?
          !steps_to_run.empty?
        end

        def steps_to_run
          @chain.select{ |key,steps| !steps.completed? }
        end

        def run
          steps_to_run.each do |k,steps|
            step = steps.next
            if has_dependencies?(step)
              arm_log.info("Installing #{steps.klass} v#{steps.step}.")
              step.run
              steps.next!
              @total += 1
            end
          end
          self
        end

        def load_installed_versions
          @total = 0
          ActiveRecord::Magic::Record.all.each do |record|
            if @chain.has_key?(record.name)
              @chain[record.name].db_version = record.version
              @total += record.version
            end
          end
        end

        def has_dependencies?(step)
          step.dependencies.each do |klass, version_required|
            klass = klass.to_s
            has_version = @chain.has_key?(klass) ? @chain[klass].db_version : 0;
            return false if version_required > has_version
          end
          true
        end

      end
    end
  end
end      
