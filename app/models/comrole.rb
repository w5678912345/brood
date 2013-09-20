class Comrole < ActiveRecord::Base
   attr_accessible :role_id, :computer_id

  belongs_to :role, :class_name => 'Role' ,:counter_cache => :computers_count
  belongs_to :computer, :class_name => 'Computer',	:counter_cache => :roles_count

end
