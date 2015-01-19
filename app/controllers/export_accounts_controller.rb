# encoding: utf-8
class ExportAccountsController < ActionController::Base
	def index
		#return render :text => params
		ss = ['normal','bslocked','discardforyears','discardbysailia']
		@accounts = Account.list_search(params).where("accounts.bind_computer_id > 0").joins("LEFT JOIN computers ON accounts.bind_computer_id = computers.id")
		@accounts = @accounts.includes(:bind_computer).reorder("computers.hostname asc")
		@accounts = @accounts.where("accounts.status not in(?)",ss) unless params[:other].blank?
		@accounts = initialize_grid(@accounts,:per_page => @accounts.count)
	end


	def normal
		account = Account.find_by_no(params[:id])
		account.update_attributes(:status=>"normal",:normal_at=>Time.now,:remark=>"out") if account

		redirect_to export_accounts_path(:server=>params[:server],:status=>"bslocked")
	end


	def restore
		ids = params[:grid][:selected] || [] if params[:grid]
		@accounts = Account.where("no in (?)",ids)
		i = @accounts.update_all(:status=>"normal",:normal_at=>Time.now)

		render :text => "<h1>恢复了#{i}个账号</h1>"
	end
end