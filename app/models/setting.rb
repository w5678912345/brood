#
class Setting < ActiveRecord::Base
   attr_accessible :ip_max_use_count, :role_timeout_minutes,:key,:val

   #ROLE_MAX_LEVEL = 

   def self.find_value_by_key key
		setting = Setting.find_by_key(key)
		return setting.val  if setting
	end
	
	def self.ip_max_use_count
		val = find_value_by_key("ip_max_use_count")
		return val == nil ? 5 : val
	end

	def self.role_max_level
		val = find_value_by_key("role_max_level")
		return val == nil ? 30 : val
	end


	def self.role_timeout_minutes
		val = find_value_by_key("role_timeout_minutes")
		return val == nil ? 10 : val
	end

	def self.ip_range_max_online_count
		val = find_value_by_key("ip_range_max_online_count")
		return val == nil ? 100 : val
	end


	def self.role_max_computers
		val = find_value_by_key("role_max_computers")
		return val == nil ? 3 : val
	end

	def self.computer_auto_binding_account_count
		val = find_value_by_key("computer_auto_binding_account_count")
		return val == nil ? 2 : val
	end


	# 账户可以绑定的计算机数量
	# def self.account_computers_count
	# 	val = find_value_by_key("account_computers_count")
	# 	return val == nil ? 1 : val
	# end

	# 计算机可以绑定的账户数量
	def self.computer_accounts_count
		val = find_value_by_key("computer_accounts_count")
		return val == nil ? 1 : val
	end

	# 账号可以上线的角色数量
	def self.account_start_roles_count
		val = find_value_by_key("account_start_roles_count")
		return val == nil ? 1 : val
	end


end
