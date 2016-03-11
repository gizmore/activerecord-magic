require 'spec_helper'
require 'ruby-prof'

describe ActiveRecord::Magic::Event do
  
#  RubyProf.start
  it "compiles and has a globe" do
    expect(ActiveRecord::Magic::Event.globe).not_to be(nil)
  end

  it "can decorate modules and classes" do
    class EventClassDecorate
      arm_events
      arm_subscribe('test1') do; end
      def initialize()
        arm_subscribe('test1') do; end
      end
    end
    EventClassDecorate.new
    module EventModuleDecorate
      arm_events
      arm_subscribe('test2') do; end
    end
    expect(ActiveRecord::Magic::Event.globe).not_to be(nil)
  end
  it "does detect duplicate code blocks" do
    load 'event_spec_helper.rb'
    load 'event_spec_helper.rb'
    object1 = EventDuplicateDecorate.new
    object1.subscribe
    object1.subscribe
    object2 = EventDuplicateDecorate.new
    object2.subscribe
    object2.subscribe

    object1.arm_subscribe('test4', object2) do |source, arg|
      puts 1, source, arg
    end
    object1.arm_subscribe('test4') do |source, arg|
      puts 2, source, arg
    end
    
    object2.arm_publish('test4', 'msg', 'foo')
    object2.arm_emit('test4', 'msg', 'foo')
  end

#  result = RubyProf.stop
#  printer = RubyProf::FlatPrinter.new(result)
#  printer.print(STDOUT)

end
