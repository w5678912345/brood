# encoding: utf-8
class ExportAccountsController < ActionController::Base
	def index
		ss = ['normal','bslocked','discardforyears','discardbysailia']
		@accounts = Account.list_search(params).where("accounts.bind_computer_id > 0").joins("LEFT JOIN computers ON accounts.bind_computer_id = computers.id")
		@accounts = @accounts.includes(:bind_computer).reorder("computers.hostname asc")
		@accounts = @accounts.where("accounts.status not in(?)",ss) unless params[:other].blank?
	end


	def normal
		account = Account.find_by_no(params[:id])
		account.update_attributes(:status=>"normal",:normal_at=>Time.now) if account

		redirect_to export_accounts_path(:server=>params[:server],:status=>"bslocked")
	end
end