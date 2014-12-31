# encoding: utf-8
class ExportAccountsController < ActionController::Base
	def index
		@accounts = Account.list_search(params).joins("LEFT JOIN computers ON accounts.bind_computer_id = computers.id").includes(:bind_computer).reorder("computers.hostname desc")
	end
end