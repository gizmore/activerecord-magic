require 'spec_helper'
describe ActiveRecord::Magic do
  # UTIL
  describe ActiveRecord::Magic::Util do
    it('offers clamping') do
      expect(4.6.clamp(1,3)).to eq(3)
      expect("-4.6".clamp(1,3)).to eq(1)
    end
    it('offers trim') do
      expect('aabbaa'.trim('a')).to eq('bb')
    end
  end
  # BASE
  describe ActiveRecord::Magic::Base do
    it('can connect to the database') do
      config = ActiveRecord::Magic::Config.new("arm.test.config.yml")
      expect(ActiveRecord::Magic::Base.arm_connect(config.database)).to be_truthy
    end
  end
  # UPDATE/INSTALL
  describe ActiveRecord::Magic::Update do
    it('should install base system') do
      expect(ActiveRecord::Magic::Update.install).to be_truthy
    end
    it('should install test classes') do
      expect(ActiveRecord::Magic::Update.run).to be_truthy
      expect(ActiveRecord::Magic::Record.where(:name => "ActiveRecord::Magic::Spec::User").first.version).to eq(2)
      expect(ActiveRecord::Magic::Record.where(:name => "ActiveRecord::Magic::Spec::Gender").first.version).to eq(1)
    end
    it('can install plain classes') do
      expect(ActiveRecord::Magic::Record.where(:name => "ActiveRecord::Magic::Spec::InstalledPojo").first.version).to eq(1)
    end
  end
  
  # ACTIVERECORD PREPARE
  describe ActiveRecord::Magic::Cache do
    it "still can truncate" do
      ActiveRecord::Magic::Spec::User.delete_all
      ActiveRecord::Magic::Spec::Gender.delete_all
      ActiveRecord::Magic::Spec::Message.delete_all
      expect(ActiveRecord::Magic::Spec::User.count).to be(0)
      expect(ActiveRecord::Magic::Spec::Gender.count).to be(0)
      expect(ActiveRecord::Magic::Spec::Message.count).to be(0)
    end
    it "still can create" do
      male = ActiveRecord::Magic::Spec::Gender.create(:name => 'male')
      female = ActiveRecord::Magic::Spec::Gender.create(:name => 'female')
      expect(ActiveRecord::Magic::Spec::Gender.count).to be(2)
      gizmore = ActiveRecord::Magic::Spec::User.create(:name => 'gizmore', :email => 'gizmore@gizmore.org', :gender => male)
      expect(gizmore.id).to be > 0
      dloser = ActiveRecord::Magic::Spec::User.create(:name => 'dloser', :email => 'dloser@gizmore.org', :gender => male)
      tehron = ActiveRecord::Magic::Spec::User.create(:name => 'tehron', :email => 'tehron@gizmore.org', :gender => male)
      famfam = ActiveRecord::Magic::Spec::User.create(:name => 'famfam', :email => 'famfam@gizmore.org', :gender => male)
      expect(ActiveRecord::Magic::Spec::User.count).to be(4)
    end
  end

  # CACHE
  describe ActiveRecord::Magic::Cache do
    users = ActiveRecord::Magic::Spec::User
    it "finds the same object twice" do
      expect(users.first).to be(users.first)
    end 
    it "finds the same object_id twice" do
      expect(users.first.object_id).to be(users.first.object_id)
    end
    it "can do uncached queries" do
      gizmore1 = users.arm_uncached{|u|u.where(:name => 'gizmore').first}
      gizmore2 = users.arm_uncached{|u|u.where(:name => 'gizmore').first}
      expect(gizmore1.object_id).not_to be(gizmore2.object_id)
    end
    it "can do cached where queries" do
      gizmore1 = users.where(:name => 'gizmore').first
      gizmore2 = users.where(:name => 'gizmore').first
      expect(gizmore1.object_id).to be(gizmore2.object_id)
    end
    it "can clear cache nicely" do
      users.arm_clear_cache
      tehron1 = users.find_or_create_by(:name => 'tehron')
      users.arm_clear_cache
      tehron2 = users.find_or_create_by(:name => 'tehron')
      expect(tehron1.object_id).not_to be(tehron2.object_id)
    end
    it "can clear cache akwardly" do
      gizmore1 = users.where(:name => 'gizmore').first
      users.arm_clear_cache
      gizmore2 = users.where(:name => 'gizmore').first
      gizmore3 = users.where(:name => 'gizmore').first
      expect(gizmore1.object_id).not_to be(gizmore2.object_id)
      expect(gizmore2.object_id).to be(gizmore3.object_id)
    end
    it "does read all rows into cache nicely" do
      users.arm_clear_cache
      expect(users.arm_get_cache.length).to be(0)
      users.all.to_a
      expect(users.arm_get_cache.length).to be(4)
      users.all.to_a
      expect(users.arm_get_cache.length).to be(4)
    end
    it "does find by mappings nicely" do
      users.arm_clear_cache
      tehron = users.find_or_create_by(:name => 'tehron')
      users.all.to_a
      expect(users.arm_get_cache.length).to be(4)
      tehrons = users.arm_get_cache.select{|key,record|record.object_id==tehron.object_id}
      expect(tehron.object_id).to be(tehrons[tehron.id].object_id)
    end
    it "respects the individual arm_cached? method with auto cache update even on rollbacks" do
      ActiveRecord::Magic::Spec::Server.delete_all
      expect(ActiveRecord::Magic::Spec::Server.arm_get_cache.count).to eq(0)
      server1 = ActiveRecord::Magic::Spec::Server.create!({name: 'localhost', online: true})
      expect(server1.class.arm_get_cache.count).to eq(1)
      server2 = ActiveRecord::Magic::Spec::Server.create!({name: 'google.de', online: false})
      expect(server1.class.arm_get_cache.count).to eq(1)
      server2.online = true; server2.save!
      expect(server1.class.arm_get_cache.count).to eq(2)
      begin
        ActiveRecord::Base.transaction do
          server3 = ActiveRecord::Magic::Spec::Server.create!({name: 'yahoo.biz', online: true})
          expect(server1.class.arm_get_cache.count).to eq(3)
          raise StandardError.new("Ooops")
        end
      rescue => e
        expect(server1.class.arm_get_cache.count).to eq(2)
      end
      server3 = ActiveRecord::Magic::Spec::Server.create!({name: 'yahoo.biz', online: true})
      expect(server1.class.arm_get_cache.count).to eq(3)
      server3.destroy!
      expect(server1.class.arm_get_cache.count).to eq(2)
      server2.delete
      expect(server1.class.arm_get_cache.count).to eq(ActiveRecord::Magic::Spec::Server.all.count)
      ActiveRecord::Magic::Spec::Server.delete_all
      expect(server1.class.arm_get_cache.count).to eq(0)
    end
    it "caches records based on table name and features inheritance of AR records" do
      class ActiveRecord::Magic::Spec::CacheInherit < ActiveRecord::Base
        self.table_name = 'arm_cache_inherited'
        arm_cache
        arm_install do |m|
          m.create_table table_name do |t|
            t.string :name
          end
        end
      end
      class ActiveRecord::Magic::Spec::CacheInherited < ActiveRecord::Magic::Spec::CacheInherit
      end
      expect(ActiveRecord::Magic::Update.run).to be_truthy
      ActiveRecord::Magic::Spec::CacheInherited.delete_all
      test = ActiveRecord::Magic::Spec::CacheInherited.find_or_create_by(:name => 'test')
    end
  end
  
  # LOCALE, TIMEZONE, ENCODING, ADVANCED CACHING
  describe ActiveRecord::Magic do
    it "installs later in runtime" do
      load 'active_record/magic/locale/arm-locale.rb'
      load 'active_record/magic/locale/arm-timezone.rb'
      load 'active_record/magic/locale/arm-encoding.rb'
      expect(ActiveRecord::Magic::Update.run).to be_truthy
      expect(ActiveRecord::Magic::Record.where(:name => "ActiveRecord::Magic::Locale").first.version).to eq(2)
      expect(ActiveRecord::Magic::Record.where(:name => "ActiveRecord::Magic::Encoding").first.version).to eq(2)
      expect(ActiveRecord::Magic::Record.where(:name => "ActiveRecord::Magic::Timezone").first.version).to eq(2)
    end
    it "is cachable by id" do
      expect(ActiveRecord::Magic::Locale.by_id(1).iso).to eq('en')
      expect(ActiveRecord::Magic::Encoding.by_id(1).iso).to eq('UTF-8')
      expect(ActiveRecord::Magic::Timezone.by_id(1).iso).to eq('Berlin')
      expect(ActiveRecord::Magic::Locale.by_id(1).object_id).to eq(ActiveRecord::Magic::Locale.first.object_id)
      expect(ActiveRecord::Magic::Encoding.by_id(1).object_id).to eq(ActiveRecord::Magic::Encoding.first.object_id)
      expect(ActiveRecord::Magic::Timezone.by_id(1).object_id).to eq(ActiveRecord::Magic::Timezone.first.object_id)
    end
    it "is cachable by iso code" do
      expect(ActiveRecord::Magic::Locale.by_iso('en').object_id).to eq(ActiveRecord::Magic::Locale.first.object_id)
      expect(ActiveRecord::Magic::Encoding.by_iso('UTF-8').object_id).to eq(ActiveRecord::Magic::Encoding.first.object_id)
      expect(ActiveRecord::Magic::Timezone.by_iso('Berlin').object_id).to eq(ActiveRecord::Magic::Timezone.first.object_id)
    end
  end
  
  describe ActiveRecord::Magic::Mail do
    it "can configure mail" do
      config = ActiveRecord::Magic::Config.new("arm.test.config.yml")
      ActiveRecord::Magic::Mail.configure(config) do |mail_config|
      end
      ActiveRecord::Magic::Mail.generic(config.mail[:staff], 'Test', 'This is a mail test to staff members.')
    end
  end

end
