require 'spec_helper'

describe ActiveRecord::Magic::Config do

  it('can create config') do
    config = ActiveRecord::Magic::Config.new("arm.test.config.yml")
    expect(config.valid?).to be(true)
  end

  it('can set config') do
    config = ActiveRecord::Magic::Config.new("arm.test.config.yml")
    config.database = { pool: 10, adapter: 'mysql2', encoding: 'utf8', database: 'arm_test', username: 'arm_test', password: 'arm_test' }
    expect(config.database[:adapter]).to eq('mysql2')
  end

  it('can reload config') do
    config = ActiveRecord::Magic::Config.new("arm.test.config.yml")
    expect(config.database[:adapter]).to eq('mysql2')
  end

  it('nils on unknown') do
    config = ActiveRecord::Magic::Config.new("arm.test2.config.yml")
    expect(config.database).to eq(nil)
  end

end
