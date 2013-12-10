# encoding: utf-8
class AccountRolesController < ApplicationController

	def index
		@records = AccountRole.get_list(params)
		params[:per_page] = params[:per_page].blank? ? 20 : params[:per_page].to_i
		#params[:per_page] = @records.count unless params[:all].blank?
		@records = @records.paginate(:page => params[:page], :per_page => params[:per_page])
	end

	def checked

	end



end