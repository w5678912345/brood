# encoding: utf-8
class AccountsController < ApplicationController

	def index

	end

	def show
		@account = Account.find_by_no(params[:id])
	end

	def list
		per_page = params[:per_page].blank? ? 20 : params[:per_page].to_i
		@accounts = Account.list_search(params).paginate(:page => params[:page], :per_page => per_page)
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
		@no = params[:no]
		session[:no] = @no

	end

	def do_checked
		@do = params[:do]
		@no = session[:no]
		@accounts = Account.where("no in (?)",@no)

		if "disable_bind" == params[:do]
			@accounts.update_all(:bind_computer_id => -1)
			return redirect_to list_accounts_path(:bind_cid=>-1)
		elsif "clear_bind" == @do
			@accounts.update_all(:bind_computer_id => 0)
			return redirect_to list_accounts_path(:bind_cid=> 0)
		end
	end

	#放回帐号
	def put
		@account = Account.find_by_no(params[:id])

		opts = {:ip => request.remote_ip,:cid => @account.online_computer_id}
		@account.api_put opts
		redirect_to account_path(@account.no)
	end

	def generate

	end

end