# encoding: utf-8
# @suxu
# 
class Api::RolesController < Api::BaseController
	layout :nil

	CODES = Api::CODES

	def close
		@role = Role.find_by_id params[:id]
		return @code = CODES[:not_find_role] unless @role
		begin
	      @code = 1 if @role.api_close params
	    rescue Exception => ex
	      @code = -1
	    end
	end

	def show
		@role = Role.find_by_id params[:id]
		return @code = CODES[:not_find_role] unless @role
		@code = 1
	end

end