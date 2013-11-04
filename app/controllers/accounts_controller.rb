# encoding: utf-8
class AccountsController < ApplicationController

	def index
		per_page = params[:per_page].blank? ? 20 : params[:per_page].to_i
		@accounts = Account.list_search(params).paginate(:page => params[:page], :per_page => per_page)
	end

	def show
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
			redirect_to account_path(@account.no)
		else
			render :action => :new
		end
	end

	def checked 
		@no = params[:no] || []
	end

	def do_checked
		@do = params[:do]
		@no = params[:no]
		@accounts = Account.where("no in (?)",@no)
		# 禁用绑定
		if "disable_bind" == @do
			@accounts.update_all(:bind_computer_id => -1)
			return redirect_to accounts_path(:bind=>-1)
		# 清空绑定
		elsif "clear_bind" == @do
			@accounts.update_all(:bind_computer_id => 0)
			return redirect_to accounts_path(:bind=> 0)
		# 添加角色
		elsif "add_role" == @do
			@accounts.each do |account|
				account.add_new_role
			end
			flash[:msg] = "#{@accounts.length}个账号,新建了角色!"
			return redirect_to accounts_path(:roles_count => 1)
		# 调用下线
		elsif "call_offline" == @do
			@accounts = @accounts.online_scope
			@accounts.each do |account|
				account.api_stop(opts = {:ip=>request.remote_ip,:cid=> account.online_computer_id,:msg=>"click"})
			end
			flash[:msg] = "#{@accounts.length}个账号被下线!"
			return redirect_to accounts_path(:online => 1)
		elsif "set_status" == @do
			status = params[:status]
    		@accounts.update_all(:status=>status) if Account::STATUS.include?(status)
    		flash[:msg] = "#{@accounts.length}个账号状态设置为 #{status}"
    		return redirect_to accounts_path(:status =>status)

		end
		return render :text => "nothing"
	end

	#
	def import
		
	end

	def do_import
		_file = params[:file]
		@sheet = Sheet.new(:file=>_file)
		@sheet.uploader = current_user
		if @sheet.save
			@sheet.to_accounts
			flash[:msg] = "新导入了#{@sheet.import_count}个账号!"
		end
		redirect_to accounts_path()
	end


end