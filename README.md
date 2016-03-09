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
    class User; arm_install(&migration) do ; end
    class User; arm_upgrade(&migration) do ; end
    class User; arm_downgrade(&migration) do; ; end


M3) arm-enum: A global enum to int table

    A proxy for polimorphism.
    Gives classnames a global auto-inc guid.

    # Usage
    class User; has_enums('arm_gender', 'gender'); end
    class Gender; is_enum('arm_gender'); end
    
    # Tests
    user.gender_id # => 12
    user.gender #=> Gender
    user.gender_id = 8 # => Arm::Exception::InvalidEnum, Arm::Exception::UnknownEnum,
    user.gender = Gender.male # => 
    User


M4) A charset and collation attribute to character columns.


M5) Global charset, timezone and locale tables


M6) Global setting helper
    has_setting :name => password, type: :password_hash, hash_func: :md5, rounds: 5, default: "test", scope: [:global, :user], nil: false
    
M7) Global thread helpers

M8) Global database stats

m9) Event and hook system

m10) arm-vars: Global variable tracking / class / instance vars which are reload safe

    A proxy for attr_reader etc which cleans variables on a reload.
    Features class vars, instance vars and ?
    
    # Usage
    class User; ams_class_var('ams_varname'); end
    class User; ams_clear_class_vars('ams_varname'); end
    class User; ams_get_class_var('ams_varname', 'foo'); end
    class User; ams_set_class_var('ams_varname', 'foo'); end
    class User; ams_remove_class_var('ams_varname'); end
    
    class User; ams_instance_var('ams_varname'); end;
    class User; ams_set_instance_var('ams_varname', 'bar'); end;
    class User; ams_r
    ActiveRecord::Magic::Reload::reset()
    ActiveRecord::Magic::Vars::reset()
    
    
    
  
  user.cvar('


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

