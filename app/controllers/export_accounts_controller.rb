# encoding: utf-8
class ExportAccountsController < ActionController::Base
	def index
		@accounts = Account.includes(:bind_computer).list_search(params)
	end
end