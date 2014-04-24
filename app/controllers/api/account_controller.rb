# encoding: utf-8
# @suxu "2727260443","password":"xyz987987
# 
class Api::AccountController < Api::BaseController
	layout :nil

	before_filter :require_remote_ip									  # 获取请求IP
	before_filter :require_computer_by_ckey, :only => [:auto,:start,:sync,:stop,:reg] #需要ckey，验证是否为有效的机器	
	#before_filter :valid_ip_use_count,					:only => [:auto] # 验证当前IP的24小时使用次数
	#before_filter :valid_ip_range_online_count,			:only => [:auto] # 验证当前IP 前三段的在线数量
	before_filter :validate_ip_can_use,					:only => [:auto]
	before_filter :require_account_by_no,				:only => [:start,:sync,:note,:stop,:look,:role_start,:role_stop,:role_note,:role_pay] # 根据帐号取得一个账户
	#before_filter :require_account_is_started,			:only => [:sync,:note,:stop] # 确定账号在线
	before_filter :require_role_by_rid,					:only => [:role_start,:role_stop,:role_note,:role_pay]
	#
	def auto
		@account  = @computer.accounts.waiting_scope(Time.now).first
		unless @account
			@code = CODES[:not_find_account]
			@computer.bind_account_when_not_find({:ip=>request.remote_ip}) if @computer.auto_binding
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

	def start
		params[:all] = true
		@code = @account.api_start params
		render :partial => '/api/accounts/data'
	end

	# 
	def stop
		@code = @account.api_stop params
		render :partial => '/api/result'
	end

	# 同步帐号属性
	def sync
		@code = @account.api_sync params
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


	def role_start
		@code = @role.api_start params
		render :partial => 'api/result'
	end

	def role_stop
		@code = @role.api_stop params
		render :partial => 'api/result'
	end

	def role_note
		@code = @role.api_note params
		render :partial => 'api/result'
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
		@account.phone_id = params[:phone_no]
		@account.save!
		@code = 1
		render :partial => '/api/result'
	end

	def get_unlock
		normal_at = Time.now.ago(30.days).since(1200.hours)
		@accounts = Account.joins(:roles).where("accounts.status = ?",'locked').reorder("roles.level desc")
		@accounts = @accounts.where("accounts.server = ?",params[:server]) unless params[:server].blank?
		@account = @accounts.uniq().first
		return render :json => {:code => CODES[:not_find_account]} unless @account
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
		@accounts = Account.joins(:roles).where("accounts.status = ?",'bslocked').where("accounts.phone_id is null").reorder("roles.level desc").order("roles.created_at desc")
		@accounts = @accounts.where("accounts.server = ?",params[:server]) unless params[:server].blank?
		@account = @accounts.uniq().first
		return render :json => {:code=>CODES[:not_find_account]}  unless @account
		render :json => {:code=>1,:id=>@account.no,:password=>@account.password,:status=>@account.status}
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

	def validate_ip_can_use
		ip = Ip.find_or_create(params[:ip])
		unless ip.can_use?
			@code = CODES[:ip_used]
			return render :partial => 'api/result' unless  @code == 0
		end
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


end