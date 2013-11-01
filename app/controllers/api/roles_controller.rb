# encoding: utf-8
# @suxu
# 
class Api::RolesController < Api::BaseController
	layout :nil
	
	##filters
	#before_filter :require_remote_ip
	#before_filter :valid_ip_use_count,					:only => [:online]
	#before_filter :valid_ip_range_online_count,			:only => [:online]
	#before_filter :require_computer_by_ckey,			:only => [:on,:off,:sync,:close,:note,:pay,:online,:lock,:unlock,:lose,:show,:bslock,:bs_unlock,:disable]
	#before_filter :require_role_by_id,					:only => [:on,:off,:sync,:close,:note,:pay,:show,:lock,:unlock,:lose,:bslock,:bs_unlock,:disable]
	#before_filter :require_online_role,					:only => [:off,:sync,:close,:note,:lock,:bslock,:bs_unlock]
	#before_filter :require_computer_eq_role,			:only => [:off,:sync,:close,:note,:pay,:lock]
	#before_filter :go_on

	def start
		@role = Role.find_by_id(params[:id])
		@code = @role.api_start params
		render :partial => 'api/result'
	end

	def stop
		@role = Role.find_by_id(params[:id])
		@code = 1
		render :partial => 'api/result'
	end

	def sync
		@role = Role.find_by_id(params[:id])
		@code = @role.api_set params
		render :partial => 'api/result'
	end

	def pay
	  @role = Role.find_by_id(params[:id])
	  @code = @role.api_pay params
	  render :partial => 'api/roles/result'
	end


	
	# actions
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

		@roles = @computer.roles.can_online_scope
		# params[:find_by_computer] = true if @roles
		if @roles.blank?
			params[:not_find_by_computer] = true
			logger.warn("====== not exists @computers.roles.can_online_scope =====")
			@roles = Role.can_online_scope.where("computers_count < ?",Setting.role_max_computers) if @roles.blank?
		end

		
		
	    #@role = Role.get_roles.where(:server => @computer.server).first
	   
	    #logger.warn("======get_roles============#{@roles.count}====================")
	    # if @roles.count > 0
	    # 	@roles = @roles.where("ip_range = ? or ip_range is NULL or ip_range2 = ? or ip_range2 is NULL",params[:ip_range] || "",params[:ip_range] || "")
	    # 	return @code = -8 if @roles.exists? == false
	    # end
	    # p "=======================#{@computer.server}"

	    @role = @roles.where("server = ? or server = '' or server is NULL", @computer.server).first
	    return @code = CODES[:not_find_role] unless @role # not find role
	    @code = @role.api_online params
	    #@role.get_sellers_by_server if @code == 1
	end

		#


	
	private 

	def require_remote_ip
		#params[:ip] = params[:ip] || request.remote_ip
		tmps = params[:ip].split(".")
		return @code = CODES[:ip_used] unless tmps.length == 4 # IP地址有效性
		params[:ip_range] = "#{tmps[0]}.#{tmps[1]}"  # IP地址的前2段
		params[:ip_range_3] = "#{tmps[0]}.#{tmps[1]}.#{tmps[2]}" # IP地址的前3段
	end

	def valid_ip_use_count
		ip = Ip.find_or_create(params[:ip])
		#return render :text => "#{ip.value}===========#{ip.use_count}====#{Setting.ip_max_use_count}"
		if ip.use_count >= Setting.ip_max_use_count
			@code = CODES[:ip_used]
			return render :partial => 'api/roles/result' unless  @code == 0
		end
	end

	def valid_ip_range_online_count
	   max_online_count = Setting.ip_range_max_online_count
	   current_online_count = Role.where(:online=>true).where("SUBSTRING_INDEX(ip,'.',3) = ?",params[:ip_range_3]).count(:id)
	   #return render :text => "#{max_online_count}-----------------#{current_online_count}"
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
	
	# 根据ckey取得对应的计算机
	def require_computer_by_ckey
		@computer = Computer.find_by_auth_key(params[:ckey]) if params[:ckey]			
		@code = CODES[:not_find_computer] unless @computer
		if @computer
			@code = CODES[:not_find_computer] unless @computer.status == 1
			@code = CODES[:computer_unchecked] unless @computer.checked
			@code = CODES[:computer_no_server] unless @computer.set_server
		end
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
