# encoding: utf-8
module TimeTask
	#早上6点执行的任务
	def self.at_06_time
		Api.reset_role
		Api.reset_ip_use_count
		Account.auto_unbind
	end

	def self.auto_stop
		Account.auto_stop
		#Role.auto_stop
		Computer.auto_stop
	end

	def self.every_60_minutes
		Account.auto_normal
	end

end