# encoding: utf-8
class ExportAccountsController < ActionController::Base
	def index
		#return render :text => params
		ss = ['delaycreate','normal','bslocked','discardforyears','discardbysailia','discardfordays','discardforweek']
		@accounts = Account.where("accounts.bind_computer_id > 0")
		@accounts = @accounts.where(:server => params[:server]) if params[:server].present?
		if params[:status].present?
			status = params[:status] == 'normal' ? ['normal','delaycreate'] : params[:status]
			@accounts = @accounts.where(:status => status)
		end
		@accounts = @accounts.includes(:bind_computer)
		@accounts = @accounts.where("accounts.status not in(?)",ss) if params[:other].present?
		
    respond_to do |format|
      format.html do
				@accounts = initialize_grid(@accounts,
					:joins => :bind_computer,
					:order => 'computers.hostname',
					:per_page => @accounts.count)
      end
      format.json do
      	@accounts = @accounts.joins(:phone)
      end
    end
	end


	def normal
		account = Account.find_by_no(params[:id])
		account.update_attributes(:status=>"normal",:normal_at=>Time.now,:remark=>"out") if account

		redirect_to export_accounts_path(:server=>params[:server],:status=>"bslocked")
	end


	def restore
		ids = params[:grid][:selected] || [] if params[:grid]
		@accounts = Account.where("no in (?)",ids)
		i = @accounts.update_all(:status=>"normal",:normal_at=>Time.now,:remark=>"out-#{Time.now.to_s}")

		render :text => "<h1>恢复了#{i}个账号</h1>"
	end
end