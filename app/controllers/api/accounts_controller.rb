# encoding: utf-8
# @suxu "2727260443","password":"xyz987987
# 
class Api::AccountsController < Api::BaseController
	layout :nil


	before_filter :require_remote_ip
	before_filter :require_computer_by_ckey,:only => [:get,:set]


	def hi
		@account  = Account.find(38)
		@code = 1 if @account
	end

	# 自动调度帐号
	def index
		@account  = Account.unline_scope.where(:status => 'normal').first
		@code = @account.api_get params
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

	# 显示帐号信息
	def show
		@account = Account.find_by_no(params[:id])
		@code = 1 if @account
		render :partial => '/api/accounts/data'
	end



	private

	def require_remote_ip
		#params[:ip] = params[:ip] || request.remote_ip
		tmps = params[:ip].split(".")
		return @code = CODES[:ip_used] unless tmps.length == 4 # IP地址有效性
		params[:ip_range] = "#{tmps[0]}.#{tmps[1]}"  # IP地址的前2段
		params[:ip_range_3] = "#{tmps[0]}.#{tmps[1]}.#{tmps[2]}" # IP地址的前3段
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

	def require_account_by_no
		@account = Account.find_by_no(params[:no])
	end

end