# encoding: utf-8
module TimeTask
	#早上6点执行的任务
	def self.at_06_time
		DailyRecords::CreateService.new.run Date.yesterday
		Api.reset_role
		Api.reset_ip_use_count
		Account.reset_today_success
		#Account.auto_unbind
		DataNode.mark
	end

	def self.reset_vit_power_roles
    Role.where(:today_success=>true).where("vit_power > 50").update_all(:today_success => false)
	end

	def self.auto_stop
		puts "auto stop at: "+Time.now.to_s
		Account.auto_stop
		#Role.auto_stop
		Computer.auto_stop
		#Account.auto_cancel_bind if Setting.auto_unbind?
	end

	def self.every_10_minutes
		Order.auto_finish
		Link.auto_idle
		AccountTask.auto_finish
	end

	def self.update_gold_price
		GoldPriceRecord.create_all_from_net
		Server.update_today_gold_price
	end

	def self.copy_role_profile(s_id,t_id)
		s = RoleProfile.find_by_id s_id
		t = RoleProfile.find_by_id t_id
		if s and t
			t.update_attributes :data => s.data
		end
	end
end