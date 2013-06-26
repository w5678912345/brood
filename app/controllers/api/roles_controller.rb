# encoding: utf-8
# @suxu
# 
class Api::RolesController < Api::BaseController
	layout :nil
	#respond_to :json
	##filters
	before_filter :require_remote_ip
	before_filter :require_role_by_id,					:only => [:on,:off,:sync,:close,:note,:pay,:show]
	before_filter :require_online_role,					:only => [:off,:sync,:close,:note,:pay]
	before_filter :require_computer_by_ckey,		:only => [:on,:off,:sync,:close,:note,:pay,:online]
	#
	def show
		@code = 1 if @role
	end

	def add
		@role = Role.new(:account=>params[:account],:password => params[:password])
		@code = @role.api_add params
		render :partial => 'api/roles/result'
	end

	#search a role online
	def online
	    @role = Role.get_role
	    return @code = CODES[:not_find_role] unless @role # not find role
	    #call
	    begin
	      @code = @role.api_online params
	    rescue Exception => ex
	      @code = -1
	    end
	end

	#----------------------- 
	#
	def on
	    begin
	      @code = @role.api_online params
	    rescue Exception => ex
	      @code = -1
	    end
	end

	#
	def off
	    begin
	       @code = @role.api_offline params
	    rescue Exception => ex
	       @code = -1
	    end
		  render :partial => 'api/roles/result'
	end

	#
	def sync
	    begin
	       @code = @role.api_sync params 
	    rescue Exception => ex
	       @code = -1
	    end
			render :partial => 'api/roles/result'
	end

	#
	def close
		begin
	      @code = 1 if @role.api_close params
	    rescue Exception => ex
	      @code = -1
	  end
	  render :partial => 'api/roles/result'
	end

	#
	def note
		@code = @role.api_note params
		render :partial => 'api/roles/result'
	end

	#
	def pay
	  @code = @role.pay params
		render :partial => 'api/roles/result'
	end

	private 

	def require_remote_ip
		params[:ip] = request.remote_ip
		@code = 0
	end
		
	def require_role_by_id
			@role = Role.find_by_id params[:id]			
			@code = CODES[:not_find_role] unless @role
			return  render :partial => 'api/roles/result' unless @role
	end
	
	#
	def require_online_role
			@code = CODES[:role_not_online] unless @role.online
			return render :partial => 'api/roles/result' unless @role.online
	end
	
	#
	def require_computer_by_ckey
			@computer = Computer.find_by_auth_key(params[:ckey]) if params[:ckey]
			@code = CODES[:not_find_computer] unless @computer
			return render :partial => 'api/roles/result' unless @computer
			params[:cid] = @computer.id
	end

	

end
