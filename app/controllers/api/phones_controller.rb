# encoding: utf-8
class Api::PhonesController < Api::BaseController

	def get
		@phone = Phone.where(:enabled=>true).where(:can_bind=>true).first
		return render :json => {:code => CODES[:not_find_phone]} unless @phone
		@account = Account.joins(:roles).where("accounts.status = ?",'bslocked').where("accounts.phone_id is null").reorder("roles.level desc").order("roles.created_at desc").uniq().first
		return render :json => {:code=>CODES[:not_find_account]}  unless @account
		render :json => {:code=>1,:no=>@phone.no,:id=>@account.no,:password=>@account.password}
	end


	def pull
		@phone_machine = PhoneMachine.find_by_name(params[:name])
		@phones = Phone.can_pull_scope(@phone_machine.id)
		@phones = @phones.select("phone_no,sms")
		#@phones.update_all("phones.status"=>"busy")
		@phones.each do |phone|
			phone.update_attributes(:status=>"busy")
		end
		phone_no = @phones.map(&:no)
		render :json=>phone_no.to_json
	end

	def pulls
		@phone_machine = PhoneMachine.find_by_name(params[:name])
		@orders = Order.joins(:phone).where("phones.status = ?","idle").where("phones.phone_machine_id =?",@phone_machine.id).where("orders.finished=0")
		@orders = @orders.select("DISTINCT(orders.phone_no) as phone_no,trigger_event as trigger_event,sms ").group("trigger_event")
		str = ""
		@orders.each do |order|
			order.link.udpate_status("busy")
			str = str+ "========#{order.link.id}"
		end
		#render :text => str
		render :json=>@orders.to_json
	end


	def sent
		@phone = Phone.find_or_create_by_no(params[:no])
		return render :json => {:code => CODES[:not_find_phone]} unless @phone
		@code = 1 if @phone.update_attributes(:status=>"sent",:sms_count=>@phone.sms_count+1,:today_sms_count=>@phone.today_sms_count+1)
		render :json=>{:code=>@code}
	end


	def bind
		@phone = Phone.find_or_create_by_no(params[:no])
		return render :json => {:code => CODES[:not_find_phone]} unless @phone
		@code = @phone.api_bind params
		render :json=>{:code=>@code}
	end

	def set_can_bind
		@phone = Phone.find_or_create_by_no(params[:no])
		@code = 1 if @phone.update_attributes(:can_bind=>params[:bind].to_i)
		render :partial => '/api/result'
	end

	

end