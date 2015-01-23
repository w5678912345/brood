class AddProfileToRole < ActiveRecord::Migration
  def up
    add_column :roles, :role_profile_id, :integer,:default => 1
    add_index :roles, :role_profile_id

  	#puts "up change roleprofile data"
  	#Role.where(:role_profile_id => 1).count.times do
    #	RoleProfile.increment_counter(:roles_count,1)
    #end
  end
  def down
  	#puts "down change roleprofile data"
  	#RoleProfile.all.each do |pf|
	#  	Role.where(:role_profile_id => pf.id).count.times do
	#    	RoleProfile.decrement_counter(:roles_count,1)
	#    end
  	#end
  	remove_index :roles,:role_profile_id
  	remove_column :roles,:role_profile_id
  end
end
