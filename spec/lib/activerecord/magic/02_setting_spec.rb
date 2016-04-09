require 'spec_helper'

class ActiveRecord::Magic::Setting::SpecSetting < ActiveRecord::Base
  
  arm_settings

  arm_setting(name: :enabled, type: :boolean, permission: :responsible, default: false)
  
  arm_install do |migration|
    migration.create_table(table_name) do |t|
      t.string :name
    end
  end
  
end

describe ActiveRecord::Magic::Setting do

  it('can decorate classes') do
    
    config = ActiveRecord::Magic::Config.new("arm.test.config.yml")
    expect(ActiveRecord::Magic::Base.arm_connect(config.database)).to be_truthy
    expect(ActiveRecord::Magic::Update.install).to be_truthy
    expect(ActiveRecord::Magic::Update.run).to be_truthy

    ActiveRecord::Magic::Setting::SpecSetting.delete_all

    object = ActiveRecord::Magic::Setting::SpecSetting.find_or_create_by(:name => 'test1')
    
    expect(object.get_setting(:enabled)).to eq(false)
    object.save_setting(:enabled, true)
    expect(object.get_setting(:enabled)).to eq(true)
    
    object = ActiveRecord::Magic::Setting::SpecSetting.find_or_create_by(:name => 'test1')
    expect(object.get_setting(:enabled)).to eq(true)
    
  end


end
