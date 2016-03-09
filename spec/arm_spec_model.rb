#
# SPEC HELPER MODELS
#
module ActiveRecord::Magic::Spec; end


# user has 2 install steps, one depending on gender.
# it enable arm_cache
# it belongs to gender
class ActiveRecord::Magic::Spec::User < ActiveRecord::Base
  arm_cache
  belongs_to :gender
  self.table_name = "armtest_user"
  arm_install do |migration|
    migration.create_table(table_name) do |t|
      t.string :name, :length => 64, :null => false, :charset => :ascii, :collate => :ascii_bin
    end
  end
  arm_install({:"ActiveRecord::Magic::Spec::Gender" => 1}) do |migration|
    migration.add_column table_name, :email,     :string,  :length => 128, :null => true
    migration.add_column table_name, :gender_id, :integer, :length => 1
  end
end


# gender has a simple install step and uses arm_cache
class ActiveRecord::Magic::Spec::Gender < ActiveRecord::Base
  arm_cache
  self.table_name = "armtest_gender"
  arm_install do |migration|
    migration.create_table(table_name) do |t|
      t.string :name
    end
  end
end


# message depends on user v2
# it has no cache
class ActiveRecord::Magic::Spec::Message < ActiveRecord::Base
  self.table_name = "armtest_message"
  arm_install({:"ActiveRecord::Magic::Spec::User" => 2}) do |migration|
    migration.create_table(table_name) do |t|
      
    end
  end
end


# the pojo just installs some arbitrary version number 1
class ActiveRecord::Magic::Spec::InstalledPojo
  extend ActiveRecord::Magic::Update::Extend
  arm_install do
  end
end
