class Comrole < ActiveRecord::Base
   attr_accessible :role_id, :computer_id

  belongs_to :role, :class_name => 'Role' ,:counter_cache => :computers_count
  belongs_to :computer, :class_name => 'Computer',	:counter_cache => :roles_count

  validates_uniqueness_of :role_id, :scope => :computer_id


  def self.reset 
  	@coms = Comrole.all
  	@coms.each do |com|
  	if com.role.computer
  		com.computer_id =  com.role.computer.id
  		com.save
  	end
  	end
  end

end
