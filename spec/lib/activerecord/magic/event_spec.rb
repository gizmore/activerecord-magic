require 'spec_helper'
require 'ruby-prof'

describe ActiveRecord::Magic::Event do
  
  # RubyProf.start

  it "compiles and has a globe" do
    expect(ActiveRecord::Magic::Event.globe).to be_a(ActiveRecord::Magic::Event::Globe)
  end

  it "can decorate modules and classes" do
    count = ActiveRecord::Magic::Event::Hook.total
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
    expect(ActiveRecord::Magic::Event::Hook.total).to be(count + 3)
  end

  it "does detect duplicate code blocks correctly" do
    count = ActiveRecord::Magic::Event::Hook.total
    load 'event_spec_helper.rb' # 1
    expect{load 'event_spec_helper.rb'}.to raise_error(ActiveRecord::Magic::DuplicateEvent) # 1
    object1 = EventDuplicateDecorate.new
    expect(object1.subscribe).to be_a(ActiveRecord::Magic::Event::Hook) # 2
    expect{object1.subscribe}.to raise_error(ActiveRecord::Magic::DuplicateEvent) # 2
    object2 = EventDuplicateDecorate.new
    expect(object2.subscribe).to be_a(ActiveRecord::Magic::Event::Hook) # 3
    expect{object2.subscribe}.to raise_error(ActiveRecord::Magic::DuplicateEvent) # 3
    expect(ActiveRecord::Magic::Event::Hook.total).to be(count + 3) # 3 hooks total
  end
  
  it "can message selective and globe" do

    count = ActiveRecord::Magic::Event::Hook.total
    object1 = EventDuplicateDecorate.new
    object2 = EventDuplicateDecorate.new

    response = 0
    object1.arm_subscribe('test4', object2) do; response = 2; end # count + 1
    object1.arm_subscribe('test4')          do; response = 1; end # count + 2
    expect(ActiveRecord::Magic::Event::Hook.total).to be(count + 2)

    object2.arm_emit('test4', 'msg', 'foo')
    expect(response).to be(2)

    object2.arm_publish('test4', 'msg', 'foo')
    expect(response).to be(1)
  end
  
  it "can delete hooks via API" do
    count = ActiveRecord::Magic::Event::Hook.total
    response = 0
    object1 = EventDuplicateDecorate.new
    hook = object1.arm_subscribe('test4') do; response = 1; end
    expect(ActiveRecord::Magic::Event::Hook.total).to be(count + 1)
    hook.remove
    expect(ActiveRecord::Magic::Event::Hook.total).to be(count)
  end

  it "does respect lifetime and cleans up" do
    response = 0
    count = ActiveRecord::Magic::Event::Hook.total
    object1 = EventDuplicateDecorate.new
    hook = object1.arm_subscribe('test4'){ response += 1 }.lifetime(1.0)
    object1.arm_publish('test4')
    expect(response).to be(1)
    object1.arm_publish('test4')
    expect(response).to be(2)
    sleep(1.0)
    object1.arm_publish('test4')
    expect(response).to be(2)
    expect(hook.removed?).to be(true)
  end

  it "does respect self signaling and max calls" do
    response = 0
    count = ActiveRecord::Magic::Event::Hook.total
    object1 = EventDuplicateDecorate.new
    hook = object1.arm_subscribe('test4'){ response += 1 }.max_calls(2).self_signal(false)
    expect(ActiveRecord::Magic::Event::Hook.total).to be(count + 1)
    object1.arm_publish('test4')
    expect(response).to be(0)
    hook.self_signal(true)
    object1.arm_publish('test4')
    object1.arm_publish('test4')
    object1.arm_publish('test4')
    expect(response).to be(2)
    expect(hook.removed?).to be(true)
    expect(ActiveRecord::Magic::Event::Hook.total).to be(count)
  end
  
  it "can link other event containers" do
    load 'event_container_spec_helper.rb'

    party1 = Party.new
    player1 = Player.new
    player2 = Player.new
    party1.add_player(player1)
    player1.arm_link(party1)
    party1.add_player(player2)
    player2.arm_link(party1)

    party2 = Party.new
    player3 = Player.new
    party2.add_player(player3)

    party3 = Party.new
    enemy1 = Player.new
    enemy2 = Player.new
    party3.add_player(enemy1)
    party3.add_player(enemy2)
    
    city = City.new
    area = Area.new
    location = Location.new
    
    
    
  end

  # result = RubyProf.stop
  # printer = RubyProf::FlatPrinter.new(result)
  # printer.print(STDOUT)

end
