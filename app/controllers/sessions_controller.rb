# encoding: utf-8
class SessionsController < ApplicationController

	def index
		per_page = params[:per_page].blank? ? 20 : params[:per_page].to_i

		@sessions =Session.paginate(:page => params[:page], :per_page => per_page)
	end


	def account
		@sessions = Session.accounts_scope
		per_page  = params[:per_page].blank? ? 20 : params[:per_page].to_i
		@sessions = @sessions.paginate(:page => params[:page], :per_page => per_page)
	end

	def role
		 @sessions = Session.roles_scope
		 per_page  = params[:per_page].blank? ? 20 : params[:per_page].to_i
		 @sessions = @sessions.paginate(:page => params[:page], :per_page => per_page)
	end


	def show

	end



end