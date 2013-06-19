# encoding: utf-8
# @suxu
# 
class Api::RolesController < Api::BaseController
	layout :nil
	respond_to :json
	

	before_filter :get_remote_ip

	#
	def on
		@role = Role.find_by_id(params[:id])
		return @code = CODES[:not_find_role] unless @role # not find role
	    #call
	    begin
	      @code = @role.api_online params
	    rescue Exception => ex
	      @code = -1
	    end
	end

	#
	def off
		@role = Role.find_by_id(params[:id])
	    return @code = CODES[:not_find_role] unless @role # not find role
	    return @code = CODES[:role_not_online] unless @role.online # role does not online 
	    #call 
	    begin
	       @code = @role.api_offline params
	    rescue Exception => ex
	       @code = -1
	    end
	end

	#
	def show
		@role = Role.find_by_id params[:id]
		return @code = CODES[:not_find_role] unless @role
		@code = 1
	end

	#
	def sync
		@role = Role.find_by_id(params[:id])
	    return @code = CODES[:not_find_role] unless @role # not find role
	    return @code = CODES[:role_not_online] unless @role.online # role does not online 
	    #call
	    begin
	       @code = @role.api_sync params 
	    rescue Exception => ex
	       @code = -1
	    end
	end

	#
	def close
		params[:ip] = request.remote_ip
		@role = Role.find_by_id params[:id]
		return @code = CODES[:not_find_role] unless @role
		begin
	      @code = 1 if @role.api_close params
	    rescue Exception => ex
	      @code = -1
	    end
	    respond_to do |format|
      		format.json { render }
   		 end
	end

	#
	def note
		@role = Role.find_by_id params[:id]
		return @code = CODES[:not_find_role] unless @role
		@code = @role.api_note params
		respond_to do |format|
			format.json { render :partial => 'api/roles/result' }
   	end
	end

	#
	def pay
		@role = Role.find_by_id params[:id]
		return @code = CODES[:not_find_role] unless @role
	  @code = @role.pay params
		render :partial => 'api/roles/result'
	end

	#search a role execute online
	def online
	    #-----------------
	    @role = Role.get_role
	    return @code = CODES[:not_find_role] unless @role # not find role
	    #call
	    begin
	      @code = @role.api_online params
	    rescue Exception => ex
	      @code = -1
	    end
	end

	

	private 
	def get_remote_ip
		params[:ip] = request.remote_ip
		@code = 0
	end

end
