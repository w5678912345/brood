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
   :role_has_closed => -9,
	 :not_valid_pay => -10,
	 :computer_unchecked => -11,
	 :not_valid_role => -12,
	 :computer_error => -13,
	 :role_server_is_nil => -14,
	 :full_use_computer => -15,
   :computer_no_server => -16,
   :not_find_task => -17,
   :not_find_role_by_ip => -18,
   :not_find_account => -19,
   :account_is_started => -20, # 账号启动
   :account_is_stopped => -21  # 账号停止
  }

  EVENTS = {}


   def self.role_auto_offline
    last_at = Time.now.ago(10.minutes).strftime("%Y-%m-%d %H:%M:%S")
    roles = Role.where(:online=>true).where("updated_at < '#{last_at}'")
		opts = Hash.new()
    roles.each do |role|
			opts[:cid] = role.computer_id
			opts[:ip] = "localhost"
      opts[:msg] =  "auto"
      role.api_offline opts if role.online
    end
  end


  # every day at 6:00 am
  def self.reset_role_vit_power
    Role.where("vit_power < 156").update_all(:vit_power => 156)
    #Note.create(:role_id=>0,:ip=>"localhost",:api_name => "reset_role")
  end

  def self.reset_role
     Role.where("vit_power < 156").update_all(:vit_power => 156)
     Note.create(:role_id=>0,:ip=>"localhost",:api_name => "reset_role")
  end

  def self.reset_bslock_role
    Role.where(:bslocked => true).where(:normal=>false).update_all(:normal => true)
  end

   # every day at 6:00 am
   def self.reset_ip_use_count
     Ip.where("use_count > 0").update_all(:use_count => 0)
     Note.create(:role_id=>0,:ip=>"localhost",:api_name => "reset_ip")
   end

   #
   def self.role_auto_reopen
      now = Time.now.strftime("%Y-%m-%d %H:%M:%S")
      roles = Role.where(:close => true).where("reopen_at <= '#{now}'")
      roles.each do |role|
          role.api_reopen({:ip=>role.ip || "localhost"})
      end
   end

  def self.role_auto_pay
      roles = Role.where("total > 0")
      roles.each do |role|
        role.pay(opts = {:ip=>"localhost",:gold=>0,:balance=>role.gold,:pay_type=>"auto"})
      end
      Note.create(:role_id=>0,:ip=>"localhost",:api_name => "auto_pay")
  end
	
  def self.reset_role_ip_range
    Role.update_all(:ip_range=>nil,:ip_range2=>nil)
  end

  #
  def self.computer_auto_stop
    
  end

end
