class Api::PhoneMachineController < Api::BaseController
	def create
		@phone_machine = PhoneMachine.new(:name => params[:name])
		if @phone_machine.save
			render json: @phone_machine, status: :created, location: @phone_machine
      	else
			render json: @phone_machine.errors, status: :unprocessable_entity
      	end
	end
	def bind_phones
		@phone_machine = PhoneMachine.find_by_name(params[:name])

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
	    	@accounts = Account.online_scope.joins(:phone).where("phone_machine_id = ? and accounts.status = ?",@phone_machine.id,'bs_unlock_fail').order("accounts.id")
	    	render json: @accounts.map {|i| {:account => i.no,:password => i.password,:phone => i.phone_id}}
    	else
    		render json: {:code => -1}
    	end
	end
end
