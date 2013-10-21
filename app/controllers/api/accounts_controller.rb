# encoding: utf-8
# @suxu "2727260443","password":"xyz987987
# 
class Api::AccountsController < Api::BaseController
	layout :nil


	before_filter :require_remote_ip									  # 获取请求IP
	before_filter :require_computer_by_ckey, :only => [:index,:get,:set,:put,:show] #需要ckey，验证是否为有效的机器	
	before_filter :valid_ip_use_count,					:only => [:index] # 验证当前IP的24小时使用次数
	before_filter :valid_ip_range_online_count,			:only => [:index] # 验证当前IP 前三段的在线数量
	before_filter :require_account_by_no,				:only => [:show,:get,:set,:put] # 根据帐号取得一个账户

	
	# 自动调度帐号
	def index
		@account  = @computer.accounts.waiting_scope.first
		unless @account
			@code = CODES[:not_find_account]
			return render :partial => '/api/result'
		end
		@code = @account.api_get params
		render :partial => '/api/accounts/data'
	end

	# 显示帐号信息
	def show
		@code = 1 if @account
		render :partial => '/api/accounts/data'
	end

	# 手动调度帐号
	def get
		@account = Account.find_by_no(params[:id])
		@code = @account.api_get params
		render :partial => '/api/accounts/data'
	end

	# 设置帐号属性
	def set
		@account = Account.find_by_no(params[:id])
		@code = @account.api_set params
		render :partial => '/api/result'
	end

	# 返还调度帐号
	def put
		@account = Account.find_by_no(params[:id])
		@code = @account.api_put params
		render :partial => '/api/result'
	end

	
	private

	# 取得请求IP
	def require_remote_ip
		#params[:ip] = params[:ip] || request.remote_ip
		tmps = params[:ip].split(".")
		return @code = CODES[:ip_used] unless tmps.length == 4 # IP地址有效性
		params[:ip_range] = "#{tmps[0]}.#{tmps[1]}"  # IP地址的前2段
		params[:ip_range_3] = "#{tmps[0]}.#{tmps[1]}.#{tmps[2]}" # IP地址的前3段
	end

	# 验证当前IP的24小时使用次数
	def valid_ip_use_count
		ip = Ip.find_or_create(params[:ip])
		#return render :text => "#{ip.value}===========#{ip.use_count}====#{Setting.ip_max_use_count}"
		if ip.use_count >= Setting.ip_max_use_count
			@code = CODES[:ip_used]
			return render :partial => 'api/result' unless  @code == 0
		end
	end

	# 验证当前IP 前三段的在线数量
	def valid_ip_range_online_count
	   max_online_count = Setting.ip_range_max_online_count
	   current_online_count = Account.online_scope.where("SUBSTRING_INDEX(online_ip,'.',3) = ?",params[:ip_range_3]).count(:id)
	   #return render :text => "#{params[:ip_range_3]}--------#{max_online_count}---------#{current_online_count}"
	   @code = CODES[:ip_used] if current_online_count > max_online_count
	   return render :partial => 'api/result' unless  @code == 0
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
		return render :partial => 'api/result' unless @code == 0
		params[:cid] = @computer.id
	end

	# 根据帐号取得账户信息
	def require_account_by_no
		@account = Account.find_by_no(params[:id])
		@code = CODES[:not_find_account] unless @account
		return  render :partial => 'api/result' unless @code == 0
	end


	


end