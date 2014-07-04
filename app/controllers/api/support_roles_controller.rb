# encoding: utf-8
# @suxu
# 
class Api::SupportRolesController < Api::BaseController
		

	def index
		@code = 0
		@account = Account.find_by_no(params[:account_id])

		return render :json=>{:code => Api::CODES[:not_find_account]} unless @account

		@support_roles = SupportRole.where(:server=>@account.server)

		@code = 1 unless @support_roles.size == 0

		render :json=>{:code=>@code,:data=>@support_roles.as_json(only: [:id, :name,:server,:line])}

	end



end