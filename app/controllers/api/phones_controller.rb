class Api::PhonesController < Api::BaseController

	def get
		@phone = Phone.where(:enabled=>true).where(:can_bind=>true).first
		return render :json => {:code => CODES[:not_find_phone]} unless @phone
		@account = Account.joins(:roles).where("accounts.status = ?",'bslocked').where("accounts.phone_id is null").reorder("roles.level desc").order("roles.created_at desc").uniq().first
		return render :json => {:code=>CODES[:not_find_account]}  unless @account
		render :json => {:code=>1,:no=>@phone.no,:id=>@account.no,:password=>@account.password}
	end

	def bind
		@phone = Phone.find_or_create_by_no(params[:no])
		@code = @phone.api_bind params
		render :partial => '/api/result'
	end

	def set_can_bind
		@phone = Phone.find_or_create_by_no(params[:no])
		@code = 1 if @phone.update_attributes(:can_bind=>params[:bind].to_i)
		render :partial => '/api/result'
	end

	

end