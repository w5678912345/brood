# encoding: utf-8
module TimeTask
	#早上6点执行的任务
	def self.at_06_time
		Api.reset_role
		Api.reset_ip_use_count
		Account.reset_today_success
		#Account.auto_unbind
		DataNode.mark
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

end