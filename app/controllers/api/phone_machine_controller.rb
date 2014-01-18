# encoding: utf-8
class Api::PhoneMachineController < Api::BaseController
	def create
		@phone_machine = PhoneMachine.new(:name => params[:name])
		if @phone_machine.save
			render json: @phone_machine, status: :created, location: @phone_machine
      	else
			render json: @phone_machine.errors, status: :unprocessable_entity
      	end
	end

	def reset
		@phone_machine = PhoneMachine.find_by_name(params[:name])
		@phone_machine.phones.update_all(:enabled=>false)
	end

	def bind_phones
		@phone_machine = PhoneMachine.find_by_name(params[:name])
		@phone_machine = PhoneMachine.create(:name => params[:name]) unless @phone_machine
		if @phone_machine.nil? 
			render json: {:code => -1}
		else
			ids = params[:phones].split ","
			old_ids = Phone.select(:no).where("no in (?)",ids).map {|i| i.no}
			ids = ids - old_ids
			Phone.where("no in (?)",old_ids).update_all(:phone_machine_id => @phone_machine)
			@phone_machine.phones.create(ids.map do |i|
				{:id => i}
			end)
			render json: {:code => 1}
		end
	end
	def can_unlock_accounts
		@phone_machine = PhoneMachine.find_by_name(params[:name])
    	if @phone_machine
	    	#因为真正的查询是在render的时候发生的，所以更新计数的操作会在查询前执行
	    	@accounts = Account.online_scope.joins(:phone).where("phone_machine_id = ? and accounts.status = ? and phone_event_count < 5",@phone_machine.id,'bslocked').order("accounts.id")
	    	targets = @accounts.map {|i| i.id}
	    	Account.where("id in (?)",targets).update_all("phone_event_count = phone_event_count + 1")

	    	render json: @accounts.map {|i| {:account => i.no,:password => i.password,:phone => i.phone_id}}
    	else
    		render json: {:code => -1}
    	end
	end
end
