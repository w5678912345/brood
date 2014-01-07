# encoding: utf-8
# @suxu "2727260443","password":"xyz987987
# 
class Api::AccountsController < Api::BaseController
	layout :nil


	before_filter :require_remote_ip									  # 获取请求IP
	before_filter :require_computer_by_ckey, :only => [:auto,:start,:sync,:stop,:show] #需要ckey，验证是否为有效的机器	
	before_filter :valid_ip_use_count,					:only => [:auto] # 验证当前IP的24小时使用次数
	before_filter :valid_ip_range_online_count,			:only => [:auto] # 验证当前IP 前三段的在线数量
	before_filter :require_account_by_no,				:only => [:show,:start,:sync,:stop] # 根据帐号取得一个账户
	#before_filter :require_account_started,				:only => [:stop,:sync]
	
	# 自动调度帐号
	def auto
		@account  = @computer.accounts.waiting_scope(Time.now).first
		unless @account
			@code = CODES[:not_find_account]
			@computer.auto_bind_accounts({:ip=>request.remote_ip,:msg=>"auto by start",:avg=>Setting.computer_auto_binding_account_count}) if @computer.auto_binding
			unless Note.where(:computer_id => @computer.id).where(:api_name=>"not_find_account").where("date(created_at) = ?",Date.today.to_s).exists?
			# 记录事件
			 Note.create(:computer_id=>@computer.id,:hostname=>@computer.hostname,:ip=>params[:ip],:server => @computer.server,
			 	:version => @computer.version,:api_name=>"not_find_account")
			 
			end
			return render :partial => '/api/result'
		end
		@code = @account.api_start params
		render :partial => '/api/accounts/data'
	end

	# 调度指定的账号
	def start
		@account = Account.find_by_no(params[:id])
		params[:all] = true
		@code = @account.api_start params
		render :partial => '/api/accounts/data'
	end

	# 
	def stop
		@account = Account.find_by_no(params[:id])
		@code = @account.api_stop params
		render :partial => '/api/result'
	end

	# 同步帐号属性
	def sync
		@account = Account.find_by_no(params[:id])
		@code = @account.api_sync params
		render :partial => '/api/result'
	end

	def note
		@account = Account.find_by_no(params[:id])
		@code = @account.api_note params
		render :partial => '/api/result'
	end

	def look
		@account = Account.find_by_no(params[:id])
		@code = 1 if @account
		render :partial => '/api/accounts/look'
	end

	# 显示帐号信息
	def show
		@code = 1 if @account
		#@accounts.online_roles = @account.roles
		render :partial => '/api/accounts/data'
	end

	def role_start

	end

	def role_note

	end

	def role_pay

	end

	def role_stop

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
			@code = CODES[:computer_no_server] if @computer.server_blank?
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

	def require_account_started
		#@code = CODES[:account_is_stopped] unless @account.is_started?
		#return  render :partial => 'api/result' unless @code == 0
	end

	
	def bind_phone
	end

end