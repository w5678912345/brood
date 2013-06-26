# encoding: utf-8
class RolesController < ApplicationController
	#filters
	load_and_authorize_resource :class => "Role"

	# actions
	def index
		@roles = Role.includes(:computer).paginate(:page => params[:page], :per_page => 15)
	end

	def online
		@roles = Role.includes(:computer).where(:online=>true).order("updated_at DESC").paginate(:page => params[:page], :per_page => 15)
		@list_title = "已在线角色"
		render :template => 'roles/index'
	end

	def offline
		@roles = Role.includes(:computer).where(:online=>false).order("updated_at DESC").paginate(:page => params[:page], :per_page => 15)
		@list_title = "未在线角色"
		render :template => 'roles/index'
	end

	def closed
		@roles = Role.includes(:computer).where(:close =>true).order("updated_at DESC").paginate(:page => params[:page], :per_page => 15)
		@list_title = "已封号"
		render :template => 'roles/index'
	end

	def not_closed
		@roles = Role.includes(:computer).where(:close =>false).order("updated_at DESC").paginate(:page => params[:page], :per_page => 15)
		@list_title = "未封号"
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
		@roles = @roles.where(:server => params[:server]) unless params[:server].blank?
		@roles = @roles.paginate(:page => params[:page], :per_page => 10)
	end

	
	def notes
		@role = Role.find(params[:id])
		@notes = @role.notes.includes(:computer).paginate(:page => params[:page], :per_page => 15)
	end

	def payments
		@role = Role.find(params[:id])
		@payments = @role.payments.paginate(:page => params[:page],:per_page => 15)
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
		@role.destroy if @role
		redirect_to roles_path()
	end

	def auto_off
		Api.role_auto_offline
		redirect_to roles_path()
	end
	
	def off
			@role = Role.find(params[:id])
			#return redirect_to roles_path() unless @role
			opts = {:ip => request.remote_ip,:cid => @role.computer_id}
			@role.api_offline opts
			redirect_to role_path(@role)
	end

	private
	def require_service
		@service = Service.new
	end

end
