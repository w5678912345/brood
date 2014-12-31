# encoding: utf-8
class AccountsController < ApplicationController

	#load_and_authorize_resource :class => "Account", :except => [:show,:edit]

	def index
		unless params[:bind_computer_id].blank?
			tmp_bind_cid = params[:bind_computer_id].to_i
			params[:bind_cid] = tmp_bind_cid if tmp_bind_cid > 0
			params[:bind] = tmp_bind_cid.to_s if tmp_bind_cid == 0 || tmp_bind_cid == -1
		end
		@accounts = Account.includes(:session).list_search(params)
		params[:per_page] = params[:per_page].blank? ? 20 : params[:per_page].to_i
		params[:per_page] = @accounts.count unless params[:all].blank?
		#@accounts = @accounts.paginate(:page => params[:page], :per_page => params[:per_page])
		@accounts = initialize_grid(@accounts,
			:order => "session_id",
			:name => 'grid',
      		:per_page=>params[:per_page])

		#export_grid_if_requested('grid' => 'grid')
		#render "wice_index"
	end

	def show
		#@account = Account.find_by_id(params[:id])
		@account = Account.find_by_no(params[:id]) if params[:id] != "0"
		@account = Account.find_by_no(params[:no]) unless @account
	end

	def merge
		server = params[:server]
		roles = Role.where("server = ?",server)
		Role.generate_accounts roles
		return  render :text => roles.count
	end

	def new
		@account = Account.new
	end

	def create
		@account = Account.new(params[:account])
		if @account.save
			@account.add_new_role(params[:n] || 1)
			redirect_to account_path(:id => 0,:no => @account.no)
		else
			render :action => :new
		end
	end

	def edit
		@account = Account.find_by_no(params[:id]) if params[:id] != "0"
		@account = Account.find_by_no(params[:no]) unless @account
		#@account.id = @account.no
	end

	def update
		@account = Account.find_by_id(params[:id]) if params[:id] != "0"
		#@account = Account.find_by_no(params[:no]) unless @account
		@account.update_attributes(params[:account])
		redirect_to account_path(:id=>0,:no=>@account.no)
	end

	def checked 
		@no = []
		@no = params[:grid][:selected] || [] if params[:grid]
	end

	def do_checked
		@do = params[:do]
		@no = params[:no]

		@accounts = Account.where("no in (?)",@no)
		# 禁用绑定
		if "disable_bind" == @do
			#
			@accounts = @accounts.stopped_scope.where("bind_computer_id != -1")
			@accounts.each do |account|
				account.do_unbind_computer(opts={:ip=>request.remote_ip,:msg=>"click",:bind=>-1})
			end
			flash[:msg] = "#{@accounts.length}个账号,被禁用绑定!"
		# 清空绑定
		elsif "clear_bind" == @do
			# 未上线并禁用绑定账户，才能启用绑定
			c = @accounts.unbind_scope.stopped_scope.update_all(:bind_computer_id => 0,:updated_at=>Time.now)
			flash[:msg] = "#{c}个账号,进入待绑定状态!"
		# 添加角色
		elsif "add_role" == @do
			@accounts.each do |account|
				account.add_new_role(params[:n] || 1,params[:profession])
			end
			flash[:msg] = "#{@accounts.length}个账号,新建了角色!"
		# 调用下线
		elsif "call_offline" == @do
			@accounts = @accounts.started_scope
			@accounts.each do |account|
				account.api_stop(opts = {:ip=>request.remote_ip,:cid=> account.online_computer_id,:msg=>"click"})
			end
			flash[:msg] = "#{@accounts.length}个账号被下线!"
		elsif "set_status" == @do
			status = params[:status]
    		i = @accounts.update_all(:status=>status) if Account::STATUS.keys.include?(status)
    		flash[:msg] = "#{i}个账号状态设置为 #{status}"
    	elsif "edit_normal_at" == @do
    		at = params[:at]
    		i= @accounts.update_all(:normal_at => at,:today_success => params[:ts].to_i)
    		flash[:msg] = "#{i}个账号修改了冷却时间"
    	elsif "bind_this_computer" == @do
    		computer = Computer.find_by_key_or_id(params[:c])
    		if computer
    			opts = {:ip=>request.remote_ip,:msg=>"bind by computer",:bind=>0}
    			#computer.clear_bind_accounts(opts) if params[:clear].to_i == 1
    			@accounts.stopped_scope.each do |account|
    				account.do_bind_computer(computer,opts)
    			end
    			return redirect_to computer_path(computer)
    		else
    			flash[:msg] = "没有对应的机器"
    		end
    	elsif "set_server" == @do
    		i =  @accounts.stopped_scope.update_all(:server => params[:server])
			flash[:msg] = "#{i}个账号的区发生改变"
		elsif "export" == @do
			render "export"
        elsif "add_sms_order" == @do
    		@accounts= @accounts.bind_phone_scope
    		@accounts.each do |account|
    			Order.create(:phone_no=>account.phone_id,:account_no=>account.no,:trigger_event=>params[:event])
    		end
    		i = @accounts.count
    		flash[:msg] = "#{i}个账号创建了工单"
    	elsif  "standing" == @do
    		i = @accounts.stopped_scope.update_all(:standing => params[:standing])
    		flash[:msg] = "#{i}个账号【站】发生改变"
		end
	end

	#
	def setting
		@status = Account::STATUS
	end

	def set
		@status = Account::STATUS
		pkeys =@status.keys
		pkeys.each do |k|
			Account::STATUS[k] = params[k].to_i
		end
		redirect_to setting_accounts_path
	end

	def update_setting
		auto_normal = params[:auto_normal]
		#redirect_to setting_accounts_path
	end

	#
	def import
		
	end

	def do_import
		_file = params[:file]
		@sheet = Sheet.new(:file=>_file)
		@sheet.uploader = current_user
		#is_auto = 
		if @sheet.save
			@sheet.to_accounts(params[:auto].to_i)
			flash[:msg] = "新导入了#{@sheet.import_count}个账号!"
		end
		redirect_to accounts_path()
	end

	#
	def group_count
		@cols = {"status"=>"状态","server"=>"服务器","roles_count"=>"角色数量","date(created_at)"=>"注册日期","bind_computer_id"=>"绑定机器"} 
		@col = params[:col] || "status"
		@records = Account.select("count(id) as accounts_count, #{@col} as col")
		@records = @records.where(:server => params[:server]) unless params[:server].blank?
		@records = @records.group(@col).reorder("accounts_count desc")
	end




end