#
class Setting < ActiveRecord::Base
   attr_accessible :ip_max_use_count, :role_timeout_minutes,:key,:val

   def self.find_value_by_key key
		setting = Setting.find_by_key(key)
		return setting.val  if setting
	end
	
	def self.ip_max_use_count
		val = find_value_by_key("ip_max_use_count")
		return val == nil ? 5 : val
	end   


	def self.role_timeout_minutes
		val = find_value_by_key("role_timeout_minutes")
		return val == nil ? 10 : val
	end



end
