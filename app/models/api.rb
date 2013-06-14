# encoding: utf-8
module Api

CODES = {
   :api_ing => 0,
   :success => 1 , 
   :errors => -1 ,
   :not_find_user => -2 ,
   :not_find_role  => -3,
   :not_find_computer  => -4,
   :role_have_online  => -5,
   :not_valid_computer  => -6,
   :role_not_online  => -7,
   :ip_used  => -8,
   :role_has_closed => -9
  }

  EVENTS = {}

  

   def self.role_auto_offline
    last_at = Time.now.ago(10.minutes).strftime("%Y-%m-%d %H:%M:%S")
    roles = Role.where(:online=>true).where("updated_at < '#{last_at}'")
    opts = Hash.new
    roles.each do |role|
      role.api_offline opts if role.online
    end
  end

  # eveary day at 6:00 am
  def self.reset_role_vit_power
    Role.where("vit_power < 156").update_all(:vit_power => 156)
  end

   # eveary day at 6:00 am
   def self.reset_ip_use_count
    Ip.where("use_count > 0").update_all(:use_count => 0)
   end

   def self.role_auto_reopen
      
   end
	
end