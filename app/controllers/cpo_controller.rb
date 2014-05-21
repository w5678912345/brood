# encoding: utf-8
class CpoController < ApplicationController


	def show
		@accounts = Cpo.get_un_stored_accounts
	end

	def import
		@accounts = Cpo.get_un_stored_accounts
		i = 0
		ids = []
		@accounts.each do |opts|
			ids << opts["id"]
			account = Account.new(:no=>opts["account_id"],:password=>opts["password"])
			i+= 1 if account.valid? && account.save
		end
		flash[:msg] = "#{i}个账号从CPO 导入"

		#
		Cpo.update_stored(ids)

		redirect_to accounts_path
	end

end