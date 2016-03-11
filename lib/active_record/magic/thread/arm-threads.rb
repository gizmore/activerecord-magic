load "active_record/magic/thread/arm-thread-decorator.rb"
##
# 
module ActiveRecord
  module Magic
    class Thread < ::Thread
      
      @@peak = 1; def self.peak; @@peak; end # Performance peak counter
      def self.count; list.length; end # Performance currently running
      
      @@fork_counter = 2 # Global execution calls counter / fork_count
      def self.fork_counter; @@fork_counter; end 
      def self.fork_counter_inc; @@fork_counter += 1; end 
        
      def initialize
        super
        now = Thread.list.length
        @@peak = now if now > @@peak
      end
      
      ####################################
      ### Debug and Exception handling ###
      ####################################
      def self.execute(&block)
        signal = ActiveRecord::Magic::Event::Signal.current
        new do
          Thread.current[:arm_event] = signal
          yield
        end
      end
      
    end
  end
end
