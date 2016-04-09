# Activerecord::Magic

ARMagic does add useful decorators to the existing Ruby ActiveRecord ecosystem.

Currently implemented:

M1) arm-cache: A global object cache

    And by saying cache, i mean it.

    # Usage
    class User; arm.cache.on(&object) do; true; end; end
    User.find_or_create_by(:name => 'a')
    User.find_or_create_by(:name => 'b')
    User.find_or_create_by(:name => 'c')

    # Tests
    User.find(1) == User.find(1) # => finds the same memory twice
    User.find(1) == User.arm.cache.first # => finds first and cache first equals
    User.find(1).object_id == User.find(1).object_id # => finds the same object_id twice
    User.all[2] == User.find(2) # => all array second find the second
    User.all.to_json == User.arm.cache.to_json # => select all json equals cache all json
    User.all.find(2) == User.arm.cache.find(2) # => provides active model via cache find second
    User.arm.cache.to_a.select{|user|; user.name == b}.first.name == "b" => # empty cache should not find anything
    User.all.arm.cache.to_a.select{|user|; user.name == b}.first.name == "b" => # Find and select all and the second user from cache
    User.arm.cache.to_a.select{|user|; user.name == b}.first.name == "b" => # empty cache should not find anything
    User.all.to_a[2] == arm.cache.all.to_a.select{|user|; user.name == b}.first => Find and select all and the second user from cache select
    User.count == 3 && User.arm.cache.count # => Cache is fully loaded.


M2) arm-upgrade: A global inline class installer and scheme beatuifier

    Decorate classes with an install routine.
    Installs itself a table for versioning the classes.

    # Usage
    class Setting < ActiveRecord::Base
      arm_install do |migration|
        migration.create_table(table_name) do |t|
          t.integer :entity_id,   :null => false
          t.integer :entity_type, :null => false
          t.string  :name,        :null => false
          t.string  :value,       :null => false
          t.timestamps :null => false
        end
      end
    end
    
M3) arm-params: A way to decorate objects with typed parameters.


M3) arm-setting: A way to persist any parameter option.

    Uses arm-params to validate and convert parameters.

    # Usage
    class User; arm_settings; arm_setting :name => 'some_setting', :type => float, :min => 1.0, :max => 2.0, :step => 0.1, default: 1.0
    class User; arm_setting :name => password, type: :password_hash, hash_func: :md5, rounds: 5, default: "test", nil: false
    

M4) A charset and collation attribute to character columns.


M5) Global charset, timezone and locale tables

    # Usage
    require 'active_record/magic/locale.rb'
    

M6) Tiny mail helper
    
M7) Global thread helpers

M8) Global database stats

m9) Event and hook system

	Another event system?
	Yes!
	
	arm-events are designed to feature my new mmorpg, ricer4-shadowlamb.
	In an rpg i need group based event signaling.
	The global cloud is the default container for publish/subscribe to work on.
	Beside publish there is signal and emit.
	
	Signal sends to a single container only.
	Publish defaults to a single container + the global. (default is global global only once)
	Emit sends to all containers that subscribed the own container.
	
	Any object can subscribe to any containers.

    # Usage
    

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activerecord-magic'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activerecord-magic

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/gizmore/activerecord-magic.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

