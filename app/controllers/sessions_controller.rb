# encoding: utf-8
class SessionsController < ApplicationController

	def index
		per_page = params[:per_page].blank? ? 20 : params[:per_page].to_i

		@sessions =Session.paginate(:page => params[:page], :per_page => per_page)
	end


	def account
		@sessions = Session.list_search(params).accounts_scope
		per_page  = params[:per_page].blank? ? 20 : params[:per_page].to_i
		@sessions = @sessions.paginate(:page => params[:page], :per_page => per_page)
	end

	def role
		 @sessions = Session.list_search(params).roles_scope
		 per_page  = params[:per_page].blank? ? 20 : params[:per_page].to_i
		 @sessions = @sessions.paginate(:page => params[:page], :per_page => per_page)
	end

	def analysis
		@account_sessions = Session.accounts_scope.select("count(id) as scount,status").group("status")
		@role_sessions = Session.roles_scope.select("count(id) as rscount,success").group("success")
	end


	def show

	end



end