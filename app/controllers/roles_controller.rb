# encoding: utf-8
class RolesController < ApplicationController
	#filters
	#before_filter :require_service

	# actions
	def index
		@roles = Role.paginate(:page => params[:page], :per_page => 10)
	end

	def show
		@role = Role.find(params[:id])
	end

	def new
		@role = Role.new
	end

	def create
		@role = Role.new(params[:role])
		if @role.save
			redirect_to roles_path()
		end
	end

	def edit
		@role = Role.find(params[:id])
	end

	def update
		@role = Role.find(params[:id])
		@role.update_attributes(params[:role])
		redirect_to roles_path()
	end

	def destroy
		@role = Role.find(params[:id])
		@role.destroy
		redirect_to roles_path()
	end

	def import
	end

	private
	def require_service
		@service = Service.new
	end

end