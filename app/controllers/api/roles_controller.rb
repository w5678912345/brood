# encoding: utf-8
# @suxu
# 
class Api::RolesController < Api::BaseController
	layout :nil
	#respond_to :json
	##filters
	before_filter :require_remote_ip
	before_filter :valid_ip_use_count,					:only => [:online]
	before_filter :valid_ip_range_online_count,			:only => [:online]
	before_filter :require_computer_by_ckey,			:only => [:on,:off,:sync,:close,:note,:pay,:online,:lock,:unlock,:lose,:show,:bslock,:bs_unlock,:disable]
	before_filter :require_role_by_id,					:only => [:on,:off,:sync,:close,:note,:pay,:show,:lock,:unlock,:lose,:bslock,:bs_unlock,:disable]
	before_filter :require_online_role,					:only => [:off,:sync,:close,:note,:pay,:lock,:bslock,:bs_unlock]
	before_filter :require_computer_eq_role,			:only => [:off,:sync,:close,:note,:pay,:lock]
	
	#after_filter  :update_role_server,					:only => [:on,:online]
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
		return @code =  CODES[:computer_no_server] unless @computer.set_server

		@roles = @computer.roles.can_online_scope
		# params[:find_by_computer] = true if @roles
		if @roles.blank?
			params[:not_find_by_computer] = true
			@roles = Role.can_online_scope.where("computers_count < ?",Setting.role_max_computers) if @roles.blank?
		end
		
		
	    #@role = Role.get_roles.where(:server => @computer.server).first
	   
	    #logger.warn("======get_roles============#{@roles.count}====================")
	    if @roles.count > 0
	    	@roles = @roles.where("ip_range = ? or ip_range is NULL or ip_range2 = ? or ip_range2 is NULL",params[:ip_range] || "",params[:ip_range] || "")
	    	return @code = -8 if @roles.exists? == false
	    end
	    @role = @roles.where("server = ? or server = '' or server is NULL", @computer.server).first
	    return @code = CODES[:not_find_role] unless @role # not find role
	    @code = @role.api_online params
	    #@role.get_sellers_by_server if @code == 1
	end

	#----------------------- 
	#
	def on
	    begin
	      #params[:auto] = false
	      @code = @role.api_online params
	    rescue Exception => ex
	      @code = -1
	    end
	    render :template => 'api/roles/online'
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
		#begin
	      @code = 1 if @role.api_close params
	   # rescue Exception => ex
	      #@code = -1
	  #end
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

	def lock
		@code = @role.api_lock params
		render :partial => 'api/roles/result'
	end

	def unlock
		@code = @role.api_unlock params
		render :partial => 'api/roles/result'
	end

	def lose
		@code = @role.api_lose params
		render :partial => 'api/roles/result'
	end

	def bslock
		@code = @role.api_bslock params
		render :partial => 'api/roles/result'
	end

	def bs_unlock
		@code = @role.api_bs_unlock params #api_bs_unlock
		render :partial => 'api/roles/result'
	end

	def disable
		@code = @role.api_disable params
		render :partial => 'api/roles/result'
	end

	private 

	def require_remote_ip
		params[:ip] = params[:ip] || request.remote_ip
		tmps = params[:ip].split(".") if params[:ip]
		params[:ip_range] = "#{tmps[0]}.#{tmps[1]}" if tmps && tmps.length > 0
		params[:ip_range_3] = "#{tmps[0]}.#{tmps[1]}.#{tmps[2]}" if tmps && tmps.length >0
		@code = 0
	end

	def valid_ip_use_count
		ip = Ip.find_or_create(params[:ip])
		@code = CODES[:ip_used] if ip.use_count >= Setting.ip_max_use_count
		return render :partial => 'api/roles/result' unless  @code == 0
	end

	def valid_ip_range_online_count
	   max_online_count = Setting.ip_range_max_online_count
	   current_online_count = Role.where(:online=>true).where("SUBSTRING_INDEX(ip,'.',3) = ?",params[:ip_range_3]).count(:id)
	   @code = CODES[:ip_used] if current_online_count > max_online_count
	   return render :partial => 'api/roles/result' unless  @code == 0
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
		#@code = CODES[:computer_no_server] unless @computer.set_server
		return render :partial => 'api/roles/result' unless @code == 0
		params[:cid] = @computer.id
	end



	def require_computer_eq_role
		unless @computer.id == @role.computer_id 
			@code = CODES[:computer_error] 
			return render :partial => 'api/roles/result'
		end
	end

	

end
