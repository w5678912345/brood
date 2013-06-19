module ApplicationHelper
	
	def time_str time
		time.strftime("%Y-%m-%d %H:%M:%S") if time
	end
	
	def ip_to_url ip
		ip.gsub(".","_") if ip
	end

end
