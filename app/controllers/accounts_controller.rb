# encoding: utf-8
class AccountsController < ApplicationController

	def index
		per_page = params[:per_page].blank? ? 20 : params[:per_page].to_i
		@accounts = Account.list_search(params).paginate(:page => params[:page], :per_page => per_page)
	end

	def show
		@account = Account.find_by_no(params[:id])
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
		@account.computers_count = -1
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

		if "disable_bind" == @do
			@accounts.update_all(:bind_computer_id => -1)
			return redirect_to accounts_path(:bind=>-1)
		elsif "clear_bind" == @do
			@accounts.update_all(:bind_computer_id => 0)
			return redirect_to accounts_path(:bind=> 0)
		elsif "add_role" == @do
			@accounts.each do |account|
				account.add_new_role
			end
			flash[:msg] = "#{@accounts.length}个账号,新建了角色!"
			return redirect_to accounts_path(:roles_count => 1)
		elsif "call_offline" 
			@accounts = @accounts.online_scope
			@accounts.each do |account|
				if account.is_online?
					account.api_put(opts = {:ip=>"localhost",:cid=> account.online_computer_id})
				end
			end
			flash[:msg] = "#{@accounts.length}个账号被下线!"
			return redirect_to accounts_path(:online => 1)
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

	#放回帐号
	def put
		@account = Account.find_by_no(params[:id])

		opts = {:ip => request.remote_ip,:cid => @account.online_computer_id}
		@account.api_put opts
		redirect_to account_path(@account.no)
	end


end