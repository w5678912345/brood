# encoding: utf-8
module TimeTask
	#早上6点执行的任务
	def self.at_06_time
		Api.reset_role
		Api.reset_ip_use_count
		Account.reset_today_success
		Account.auto_unbind
		DataNode.mark
	end

	def self.auto_stop
		Account.auto_stop
		#Role.auto_stop
		Computer.auto_stop
		Link.auto_idle
	end

end