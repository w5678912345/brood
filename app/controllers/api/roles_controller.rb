# encoding: utf-8
# @suxu
# 
class Api::RolesController < Api::BaseController
	layout :nil
	
	#  根据ID查询角色
	before_filter :require_role_by_id,	:only => [:start,:stop,:sync,:pay]
	

	def start
		@code = @role.api_start params
		render :partial => 'api/result'
	end

	def stop
		@code = @role.api_stop params
		render :partial => 'api/result'
	end

	def sync
		@code = @role.api_sync params
		render :partial => 'api/result'
	end

	def pay
	   @code = @role.api_pay params
	   render :partial => 'api/result'
	end

	def show
		@code = 1 if @role
	end

	def add
		@role = Role.new(:account=>params[:account],:password => params[:password])
		@code = @role.api_add params
		render :partial => 'api/result'
	end

	private 
	def require_role_by_id
		@role = Role.find_by_id params[:id]			
		@code = CODES[:not_find_role] unless @role
		return  render :partial => 'api/result' unless @role
	end
end
