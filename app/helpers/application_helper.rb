#encoding: utf-8
module ApplicationHelper
	
	def time_str time
		time.strftime("%Y-%m-%d %H:%M:%S") if time
	end
	
	def ip_to_url ip
		ip.gsub(".","_") if ip
	end

# 	<%= raw('<i class="icon-lock" title="帐号锁定"></i>') if role.locked %>
# <%= raw('<i class="icon-warning-sign" title="密码丢失"></i>') if role.lost %>
# <%= raw('<i class="icon-flag" title="卖家角色"></i>') if role.is_seller %>

	def role_icon role
		return '' unless role
		icon_html = ''
		icon_html = icon_html+'<i class="icon-lock" title="帐号锁定"></i>' if role.locked
		icon_html = icon_html+'<i class="icon-warning-sign" title="密码丢失"></i>' if role.lost
		icon_html = icon_html+'<i class="icon-flag" title="卖家角色"></i>' if role.is_seller
		return raw(icon_html)
	end

	def event_badge event,times
		cls = ""
		cls = "badge-info" if ["online","offline","reopen","pay","reset_ip","reset_role"].include?(event)
		cls = "badge-success" if event == "success"
		cls = "badge-warning" if ["lock","AnswerVerifyCode"].include?(event) 
		cls = "badge-important" if event == "close"
		cls = "badge-inverse" if event  == "lose"
		html = "<span class='badge #{cls}'>#{event}</span>"
		html = html + " (#{times})次" if times > 0
		return html.html_safe

	end

end
