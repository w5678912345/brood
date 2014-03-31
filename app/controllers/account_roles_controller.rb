# encoding: utf-8
class AccountRolesController < ApplicationController

	def index
		@records = AccountRole.get_list(params)
		params[:per_page] = params[:per_page].blank? ? 20 : params[:per_page].to_i
		params[:per_page] = @records.count unless params[:all].blank?
		@records = initialize_grid(@records,:per_page=>params[:per_page])#@records.paginate(:page => params[:page], :per_page => params[:per_page])
	end


	def account
		
	end

	def role

	end

	def checked

	end



end