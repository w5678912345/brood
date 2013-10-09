# encoding: utf-8
class AccountsController < ApplicationController

	def index

	end

	def list
		per_page = params[:per_page].blank? ? 20 : params[:per_page].to_i
		@accounts = Account.list_search(params).paginate(:page => params[:page], :per_page => per_page)
	end

	def merge
		server = params[:server]
		roles = Role.well_scope.where("server = ?",server)
		Role.generate_accounts roles
		return  render :text => roles.count
	end

	def generate

	end

end