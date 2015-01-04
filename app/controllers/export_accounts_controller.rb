# encoding: utf-8
class ExportAccountsController < ActionController::Base
	def index
		@accounts = Account.list_search(params).joins("LEFT JOIN computers ON accounts.bind_computer_id = computers.id").includes(:bind_computer).reorder("computers.hostname desc")
	end


	def normal
		account = Account.find_by_no(params[:id])
		account.update_attributes(:status=>"normal",:normal_at=>Time.now) if account

		redirect_to export_accounts_path(:server=>params[:server],:status=>"bslocked")
	end
end