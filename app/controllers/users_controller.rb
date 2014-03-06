# encoding: utf-8
class UsersController < ApplicationController

	load_and_authorize_resource :class => "User"
	
	def index
		#@users = User.paginate(:page => params[:page], :per_page => 10)
		@users = initialize_grid(User)
		render "wice_index"
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(params[:user])
		if @user.save
				redirect_to users_path
		else
				render :action => "new"
		end
	end

	def edit
		@user = User.find_by_id(params[:id])

	end

	def update
		@user = User.find_by_id(params[:id])
		@user.update_attributes(params[:user])
		redirect_to users_path
	end

	def destroy
		@user = User.find_by_id(params[:id])
		@user.destroy if @user && !@user.is_admin		
		redirect_to users_path
	end

end
