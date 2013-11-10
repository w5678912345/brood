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
		icon_html = icon_html+' <i class="icon-warning-sign" title="密码丢失"></i>' if role.lost
		icon_html = icon_html+' <i class="icon-magnet" title="交易锁定"></i>' if role.bslocked
		icon_html = icon_html+' <i class="icon-stop" title="解锁失败"></i>' if role.unbslock_result == false
		icon_html = icon_html+' <i class="icon-fire" title="解锁成功"></i>' if role.unbslock_result == true
		icon_html = icon_html+' <i class="icon-flag" title="IP: '+role.ip_range+'"></i>' unless role.ip_range.blank?
		icon_html = icon_html+' <i class="icon-flag" title="IP: '+role.ip_range2+'"></i>' unless role.ip_range2.blank?

		if role.close
			icon_html = icon_html+' <i class="icon-remove-sign" title="已经封号"></i>'
			icon_html = icon_html + " <span class='label label-important' title='重开时间#{time_str role.reopen_at}'>(#{role.close_hours}小时)</span>"
		end
		
		return raw(icon_html)
	end

	def event_badge event,times
		cls = ""
		cls = "badge-info" if ["online","offline","reopen","pay","reset_ip","reset_role"].include?(event)
		cls = "badge-success" if["success","bs_unlock"].include?(event)
		cls = "badge-warning" if ["lock","AnswerVerifyCode"].include?(event) 
		cls = "badge-important" if ["bslock","close"].include?(event) #if event == "close"
		cls = "badge-inverse" if event  == "lose"
		html = "<span class='badge #{cls}'>#{event}</span>"
		html = html + " (#{times})次" if times > 0
		return html.html_safe

	end


	def status_tag status
		#return raw('<span class="badge badge-success">正常</span>') if status == 1
		return raw('<span class="badge badge-warning">异常</span>') if status != '1' && status != 'normal' && status != 1
	end

	def boolean_tag bool
		return raw('<span class="label label-success">Yes</span>') if bool
		return raw('<span class="label label-important">No</span>') 
	end

	def computer_tag computer
		return unless computer
		return link_to("#{computer.hostname}",computer_path(computer.id)) + notes_link_tag(:cid => computer.id)
	end

	def session_tag sid
		return unless sid
		return notes_link_tag(:session_id=>sid)
	end

	def account_tag account
		#return account.class
		return unless account
		account = account.no if account.class.to_s != 'String'
		return link_to(account,account_path(:id=>0,:no=>account)) + notes_link_tag(:account=>account) if account.include?(".")
		return link_to(account,account_path(account),:target => "_blank") + notes_link_tag(:account=>account) 
	end

	#
	def role_tag role_id
		return unless role_id > 0 
		return link_to(role_id,role_path(role_id),:target => "_blank") + notes_link_tag(:role_id=>role_id) 
	end

	def notes_link_tag opts
		link_to(raw('<span class="icon-list-alt" title="查看记录"></span>'),notes_path(opts),:target => "_blank")
	end


	def note_tag note
		
	end



	def account_bind_tag account
		return unless account
		return "未绑定" if account.bind_computer_id  == 0
		return "禁用绑定" if account.bind_computer_id  == -1
		return computer_tag(account.bind_computer) if account.bind_computer
	end


	def session_result_tag session
		
	end

end
