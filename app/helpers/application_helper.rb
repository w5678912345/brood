#encoding: utf-8
module ApplicationHelper
	
	def time_str time
		time.strftime("%Y-%m-%d %H:%M:%S") if time
	end
	
	def ip_to_url ip
		ip.gsub(".","_") if ip
	end

	def event_badge event,times
		cls = ""
		cls = "badge-info" if ["online","offline","reopen","pay","reset_ip","reset_role"].include?(event)
		cls = "badge-success" if event == "success"
		cls = "badge-warning" if ["lock","AnswerVerifyCode"].include?(event) 
		cls = "badge-important" if event == "close"
		cls = "badge-inverse" if event  == "lose"
		html = "<span class='badge #{cls}'>#{event}</span>"
		html = html + "(#{times})次" if times > 0
		return html.html_safe

	end

end
