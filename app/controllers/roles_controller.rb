# encoding: utf-8
class RolesController < ApplicationController
	#filters
	#before_filter :require_service

	# actions
	def index
		@roles = Role.includes(:computer).paginate(:page => params[:page], :per_page => 10)
	end

	def can
		@roles = Role.can_online_scope.paginate(:page => params[:page], :per_page => 10)
	end

	def online
		@roles = Role.where(:online=>true).order("updated_at DESC").paginate(:page => params[:page], :per_page => 10)
		@list_title = "Online Roles"
		render :template => 'roles/index'
	end

	def offline
		@roles = Role.where(:online=>false).order("updated_at DESC").paginate(:page => params[:page], :per_page => 10)
		@list_title = "Offline Roles"
		render :template => 'roles/index'
	end

	def closed
		@roles = Role.where(:close =>true).order("updated_at DESC").paginate(:page => params[:page], :per_page => 10)
		@list_title = "Closed Roles"
		render :template => 'roles/index'
	end

	def not_closed
		@roles = Role.where(:close =>false).order("updated_at DESC").paginate(:page => params[:page], :per_page => 10)
		@list_title = "Not closed Roles"
		render :template => 'roles/index'
	end

	def search
		@roles = Role.includes(:computer)
		@roles = @roles.where(:close => params[:closed]) unless params[:closed].blank?
		@roles = @roles.where(:online => params[:online]) unless params[:online].blank?
		@roles = @roles.where("level >= #{params[:min_level]}") unless params[:min_level].blank?
		@roles = @roles.where("level <= #{params[:max_level]}") unless params[:max_level].blank?
		@roles = @roles.where("vit_power >= #{params[:min_vit]}") unless params[:min_vit].blank?
		@roles = @roles.where("vit_power <= #{params[:max_vit]}") unless params[:max_vit].blank?
		@roles = @roles.paginate(:page => params[:page], :per_page => 10)
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