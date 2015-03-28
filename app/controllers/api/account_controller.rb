# encoding: utf-8
# @suxu "2727260443","password":"xyz987987
# 
class Api::AccountController < Api::BaseController
	include AccountAction
	layout :nil

	before_filter :require_remote_ip									  # 获取请求IP
	before_filter :require_computer_by_ckey, :only => [:auto,:start,:sync,:stop,:reg,:check_ip,:look,:get_phone] #需要ckey，验证是否为有效的机器	
	#before_filter :valid_ip_use_count,					:only => [:auto] # 验证当前IP的24小时使用次数
	#before_filter :valid_ip_range_online_count,			:only => [:auto] # 验证当前IP 前三段的在线数量
	before_filter :check_valid_ip,					:only => [:auto]
	before_filter :require_account_by_no,				:only => [:start,:sync,:note,:stop,:look,:get_phone,:role_start,:role_stop,:role_note,:role_pay,:set_rms_file,:support_roles,:use_ticket,:role_profile] # 根据帐号取得一个账户
	#before_filter :require_account_is_started,			:only => [:sync,:note,:stop] # 确定账号在线
	before_filter :require_role_by_rid,					:only => [:role_start,:role_stop,:role_note,:role_pay,:role_profile]
	before_filter :get_account_session,		:only =>[:sync,:note,:stop,:role_start,:role_stop,:role_note,:role_profile]	#

	def auto
		@account = Accounts::AllocateService.new(@computer,params[:ip]).run if @account.nil?

		if @account
			@code = 1
			Accounts::StartService.new(@account).run @computer,params[:ip]
      
      #后面的部分其实应该是在登陆游戏后再判断的
			@online_roles = Accounts::AllocateRoleService.new(@account).run params[:all] == true
			@computer.update_attributes :msg => 'normal' if @computer.msg != 'normal'
			render :partial => '/api/accounts/data'
		else
			@code = CODES[:not_find_account]

			@computer.update_attributes :msg => 'not_find_account' if @computer.msg != 'not_find_account'
			return render :partial => '/api/result'
		end
	end

	def valid_game_version
		@bolt_version = BotVersion.find_by_version(params[:version])
		game_version = ''
		game_version = @bolt_version.game_versions if @bolt_version
		return render :json => {:code => CODES[:success],:game_versions => game_version}
	end

	def start
		params[:all] = true
		#return render :text => params
		if @account.is_started? == false
			Accounts::StartService.new(@account).run @computer,params[:ip]
	    #后面的部分其实应该是在登陆游戏后再判断的
			@online_roles = Accounts::AllocateRoleService.new(@account).run true
			@code = 1
		else
			@code = CODES[:account_is_started]
		end
		render :partial => '/api/accounts/data'
	end

	# 
	def stop
		@code = CODES[:account_is_stopped]

		if @account.account_session
			@code = 1
			@account.account_session.stop params[:success]=='1',params[:msg]
		end
		
		render :partial => '/api/result'
	end

	# 同步帐号属性
	def sync
		#build role attribute
		role_attr_names = Role.columns.map {|c| c.name }
		roles_attr = params.reject{|key,value| role_attr_names.include?(key) == false}

		@code = @account.api_sync params[:rid],roles_attr,{money_point: params[:money_point]},params[:account_session] || {}
		render :partial => '/api/result'
	end

	def note
		@code = @account.api_note params
		render :partial => '/api/result'
	end

	def look
		@code = 1 if @account
		render :partial => '/api/accounts/look'
	end

	def get_phone
		if @account.phone and @account.phone.enabled and @account.phone.online
			render :json => {:code => CODES[:success],:phone_id => @account.phone_id}
		else
			render :json => {:code => CODES[:errors]}
		end
	end

	def role_start
		if @account.account_session.nil?
			@code = CODES[:account_is_stopped]
		else
			@code = @account.account_session.start_role(@role)
		end
		render :partial => 'api/result'
	end

	def role_stop
		@code = @role.api_stop params
		render :partial => 'api/result'
	end

	def role_note
		@code = @role.api_note params
		@account.account_session.update_attributes(:lived_at => Time.now)
		render :partial => 'api/result'
	end
	def role_profile
		@pf = @role.role_profile
		send_data @pf.data
	end
	def role_pay
		@code = @role.api_pay params
		render :partial => 'api/result'
	end


	def role_start_count
		 @records = Note.where(:api_name => "role_start").where(:ending=>false)
		 @records = @records.where(:level => params[:level].to_i) unless params[:level].blank?
		 @records = @records.where(:target => params[:target]) unless params[:target].blank?
		 @start_count = @records.count("DISTINCT role_id")
		 render :json => {:role_start_count => @start_count}
	end

	# @records = Note.where(:api_name => "role_start").where(:ending=>false)
	# 	 @records = @records.where(:level => params[:level].to_i) unless params[:level].blank?
	# 	 counts = []
	# 	 unless params[:target].blank?
	# 	 	targets = params[:target].split(",")
	# 	 	targets.each do |t|
	# 	 		count = @records.where(:target=>t).count("DISTINCT role_id")
	# 	 		counts << count
	# 	 	end
	# 	 end
	# 	 render :json => {:targets => targets, :counts => counts}
		 #@records = @records.where(:target => params[:target]) unless 

	def reg
		@account = Account.new(:no=>params[:id],:password=>params[:pwd],:remark=>params[:remark],:is_auto=>true)
		@code = @account.api_reg params,@computer
		render :partial => '/api/result'
	end
	def bind_phone
		@account = Account.find_by_no(params[:id])
		return render :json => {:code => CODES[:not_find_account]} unless @account
		@account.phone_id = params[:phone_no]
		@account.save!
		@code = 1
		render :partial => '/api/result'
	end

	def get_unlock
		ids = AccountTask.where(:event=>"unlock").where(:status=>"doing").map(&:account)
		#normal_at = Time.now.ago(30.days).since(1200.hours)
		@accounts = Account.joins(:roles).where("accounts.status = ?",'locked').reorder("roles.level desc")
		@accounts = @accounts.where("accounts.server = ?",params[:server]) unless params[:server].blank?
		@accounts = @accounts.where("accounts.no not in (?)",ids) if ids.length > 0
		@account = @accounts.uniq().first
		return render :json => {:code => CODES[:not_find_account]} unless @account
		AccountTask.create(:event=>"unlock",:account=>@account.no)
		render :json => {:code=>1,:id=>@account.no,:password=>@account.password,:status=>@account.status}
	end

	def unlock
		# @phone = Phone.where(:can_unlock=>true).find_by_no(params[:phone_id])
		# return render :json => {:code => CODES[:not_find_phone]} unless @phone
		
		@account = Account.where(:status=>"locked").find_by_no(params[:id])
		return render :json => {:code => CODES[:not_find_account]} unless @account
		result = params[:result]
		if result == "normal"
			@account.password = params[:pwd] unless params[:pwd].blank?
			@code = 1 if @account.update_attributes(:status=>"normal",:normal_at=>Time.now,:unlock_phone_id=>params[:phone_id],:unlocked_at=>Time.now)
			@account.do_unbind_computer(opts={:ip=>"localhost",:msg=>"auto by unlock",:bind=>0})
		elsif result == "recycle"
			@code = 1 if @account.update_attributes(:status=>"recycle",:normal_at=>Time.now.since(10.years))
		else
			@code = 0
		end
		@account.update_attributes(:remark=>"#{@account.remark} #{result} #{params[:msg]}")
		render :json=>{:code=>@code,:msg=>result}
	end

	def get_bslock
		ids = AccountTask.where(:event=>"bslock").where(:status=>"doing").map(&:account)
		@accounts = Account.joins(:roles).where(:rms_file=>true).where("accounts.status = ?",'bslocked').where("accounts.phone_id is null or accounts.phone_id = ''").reorder("roles.level desc").order("roles.created_at desc")
		@accounts = @accounts.where("accounts.server = ?",params[:server]) unless params[:server].blank?
		@accounts = @accounts.where("accounts.no not in (?)",ids) if ids.length > 0
		@account = @accounts.uniq().first
		return render :json => {:code=>CODES[:not_find_account]}  unless @account
		AccountTask.create(:event=>"bslock",:account=>@account.no)
		render :json => {:code=>1,:id=>@account.no,:password=>@account.password,:status=>@account.status}
	end

	def upate_attr
		@account = Account.find_by_no(params[:id])
		return render :json => {:code => CODES[:not_find_account]} unless @account
		@account.server = params[:server] unless params[:server].blank?
		@account.password = params[:pwd] unless params[:pwd].blank?
		unless params[:status].blank? && Account::STATUS.has_key?(params[:status])
			@account.status = params[:status]
			@account.normal_at = Time.now.since(Account::STATUS[params[:status]].hours)
		end
		@account.save
		render :json => {:code=>1,:id=>@account.no}
	end

	def support_roles
	 	@support_roles =  SupportRole.where(:server=>@account)
	 	
	 	
	end


	def check_ip
		@account = Account.find_by_no(params[:id])
		return render :json => {:code => CODES[:not_find_account]} unless @account
		current_ip = request.remote_ip
		online_ip = @account.online_ip
		result = (current_ip == online_ip)
		Note.create(:account=>@account.no,:ip=>current_ip,:msg=>"#{result}-#{online_ip}",:api_name=>"check_ip",:success=>result,:computer_id=>@computer.id)
		return render :json => {:code => 1, :result => result,:current_ip=>current_ip,:online_ip=>online_ip}
	end


	#id , role_id, points, gold ,msg
	def use_ticket
		ticketRecord = TicketRecord.new(:account=>@account.no,:server=>@account.server,:points=>params[:points],:gold=>params[:gold],:msg=>params[:msg])
		role = Role.find_by_id(params[:role_id])
		if role
			ticketRecord.role_id = role.id
			ticketRecord.role_name = role.name
		end
		
		if ticketRecord.save
			return render :json => {:code => 1}
		else
			return render :json => {:code => 0,:msg=>"error"}
		end
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

	def check_valid_ip
		return if Setting.need_ip_limit? == false
		#@ip = IPAddr.new params[:ip]
		ip_c = get_ip_c params[:ip]
		session_records = AccountSession.where('ip = ? and lived_at > ?',params[:ip],24.hours.ago).includes(:account => :roles)
		if ip_used_in_records session_records
			@code=CODES[:ip_used]
			@computer.update_attributes :msg => 'ip_used'
			return render :json => {:code=>@code,:msg=>"#{params[:ip]}"}
		end
		return if @account
		if AccountSession.where(:ip_c => ip_c,:finished => false).count > Setting.ip_range_max_online_count
			@code=CODES[:ip_used]
			@computer.update_attributes :msg => 'ip_used'
			return render :json => {:code=>@code,:msg=>"ip c online too match:#{params[:ip]}"}
		end

		session_records = AccountSession.where('ip_c = ? and lived_at > ?',ip_c,Setting.in_range_minutes.minutes.ago).includes(:account => :roles)
		#
		#if ip_used_in_records session_records,Setting.ip_range_start_count
		if session_records.count >= Setting.ip_range_start_count
			@code=CODES[:ip_used]
			@computer.update_attributes :msg => 'ip_used'
			return render :json => {:code=>@code,:msg=>"ip c used:#{ip_c}"}
		end
	end

	def ip_used_in_records(records,permit_count = 1)
		@account_session = (records.select {|e| e.account.can_start?}).first
		#binding.pry
		if @account_session
			@account = @account_session.account
		end
		#如果没历史，或者历史中得账号还可以用，那么ip可用
		(records.size < permit_count) == false and @account.nil?
	end
	def get_ip_c ip_str
		part = ip_str.split '.'
		part[0]+'.'+part[1]+'.'+part[2]+'.0'
	end

	# 根据ckey取得对应的计算机
	def require_computer_by_ckey
		@computer = Computer.find_by_auth_key(params[:ckey]) if params[:ckey]		
		@code = CODES[:not_find_computer] unless @computer
		if @computer
			@code = CODES[:computer_exception] unless @computer.status == 1
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

	# 根据ID 查询角色信息
	def require_role_by_rid
		@role = @account.roles.find_by_id(params[:rid])			
		@code = CODES[:not_find_role] unless @role
		return  render :partial => 'api/result' unless @role
	end
	def get_account_session
		@account_session = AccountSession.where(:finished => false,:account_id => params[:id]).first
	end
end