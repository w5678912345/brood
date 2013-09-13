# encoding: utf-8
class RolesController < ApplicationController
	#filters
	load_and_authorize_resource :class => "Role"

	# actions
	def index
		@roles = Role.includes(:computer).paginate(:page => params[:page], :per_page => 15)
	end

	def online
		@roles = Role.includes(:computer).where(:online=>true).paginate(:page => params[:page], :per_page => 15)
		@list_title = "已在线角色"
		render :template => 'roles/index'
	end

	def offline
		@roles = Role.includes(:computer).where(:online=>false).paginate(:page => params[:page], :per_page => 15)
		@list_title = "未在线角色"
		render :template => 'roles/index'
	end

	def closed
		@roles = Role.includes(:computer).order("reopen_at ASC").where(:close =>true).paginate(:page => params[:page], :per_page => 15)
		@list_title = "已封号"
		render :template => 'roles/index'
	end

	def not_closed
		@roles = Role.includes(:computer).where(:close =>false).paginate(:page => params[:page], :per_page => 15)
		@list_title = "未封号"
		render :template => 'roles/index'
	end

	def locked
		@roles = Role.includes(:computer).where(:locked => true).paginate(:page => params[:page], :per_page => 15)
		@list_title = "已锁定角色"
		render :template => 'roles/index'
	end

	def unlocked
		@roles = Role.includes(:computer).where(:locked => false).paginate(:page => params[:page], :per_page => 15)
		@list_title = "未锁定角色"
		render :template => 'roles/index'
	end

	def lost
		@roles = Role.includes(:computer).where(:lost => true).paginate(:page => params[:page], :per_page => 15)
		@list_title = "已丢失角色"
		render :template => 'roles/index'
	end

	def unlost
		@roles = Role.includes(:computer).where(:lost => false).paginate(:page => params[:page], :per_page => 15)
		@list_title = "未丢失角色"
		render :template => 'roles/index'
	end


	def waiting
		@roles = Role.includes(:computer).can_online_scope
		role_max_level = Setting.find_value_by_key("role_max_level")
    @roles = @roles.where("level <= #{role_max_level}") if role_max_level
		@roles = @roles.paginate(:page => params[:page], :per_page => 15)
		@list_title = "即将上线"
		render :template => 'roles/index'
	end

	def bslocked
		@roles = Role.includes(:computer).where(:bslocked => true).paginate(:page => params[:page], :per_page => 15)
		@list_title = "交易锁定角色"
		render :template => 'roles/index'
	end



	def reset_vip_power
		Api.reset_role_vit_power
		redirect_to roles_path
	end

	def search
		@roles = Role.includes(:computer)
		#@roles = @roles.where(:id => params[:id]) unless params[:id].blank? #where(:id => params[:id].to_i) unless params[:id].blank?
		@roles = @roles.where(:close => params[:closed]) unless params[:closed].blank?
		@roles = @roles.where(:close_hours => params[:close_hours].to_i) unless params[:close_hours].blank?
		@roles = @roles.where(:bslocked => params[:bslocked]) unless params[:bslocked].blank?
		@roles = @roles.where(:online => params[:online]) unless params[:online].blank?
		@roles = @roles.where(:lost => params[:lost]) unless params[:lost].blank?
		@roles = @roles.where(:status => params[:status].to_i) unless params[:status].blank?
		@roles = @roles.where(:id => params[:role_id]) unless params[:role_id].blank?
		@roles = @roles.where(:locked => params[:locked]) unless params[:locked].blank?
		@roles = @roles.where(:bslocked => true).where(:unbslock_result => params[:bs_unlock]) unless params[:bs_unlock].blank?
		@roles = @roles.where("level >= #{params[:min_level]}") unless params[:min_level].blank?
		@roles = @roles.where("level <= #{params[:max_level]}") unless params[:max_level].blank?
		@roles = @roles.where("vit_power >= #{params[:min_vit]}") unless params[:min_vit].blank?
		@roles = @roles.where("vit_power <= #{params[:max_vit]}") unless params[:max_vit].blank?
		@roles = @roles.where(:server => params[:server]) unless params[:server].blank?
		#@roles = @roles.where(:id => params[:id]) unless params[:id].blank? #where(:id => params[:id].to_i) unless params[:id].blank?
		per_page = params[:per_page].blank? ? 20 : params[:per_page].to_i
		@roles = @roles.paginate(:page => params[:page], :per_page => per_page)
	end

	def unlock
		@role = Role.find_by_id(params[:id])
		@role.update_attributes(:locked => false) if @role
		redirect_to locked_roles_path
	end

	def regain
		@role = Role.find_by_id(params[:id])
		@role.update_attributes(:lost => false) if @role
		redirect_to lost_roles_path
	end

	
	def notes
		@date = Date.parse params[:date] unless params[:date].blank?
		@time = Time.new(@date.year,@date.month,@date.day,6,0,0) if @date
		@role = Role.find_by_id(params[:id])
		@notes = @role.notes
		@notes = @notes.where(:api_name => params[:event]) unless params[:event].blank?
		@notes = @notes.day_scope(@time) if @time


		@notes = @notes.includes(:computer).paginate(:page => params[:page], :per_page => 15)
	end

	def payments
		@role = Role.find_by_id(params[:id])
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
		#return render :text => params.class
		@role = Role.find(params[:id])
		@role.update_attributes(params[:role])
		redirect_to roles_path()
	end

	def hello

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

	def reopen
		@role = Role.find(params[:id])
		opts = {:ip => request.remote_ip,:cid => @role.computer_id}
		@role.api_reopen opts
		redirect_to role_path(@role)
	end

	def reopen_all
			Api.role_auto_reopen
			redirect_to closed_roles_path
	end

	def enable
		@role = Role.find_by_id(params[:id])
		@role.update_attributes(:status => 1) if @role
		redirect_to role_path(@role)
	end


	def task
		session[:cids] = nil
		ids = params[:ids]
   		return redirect_to roles_path unless ids
		session[:rids] = ids
      	return redirect_to pre_task_path(params[:task_id])
	end



	private
	def require_service
		@service = Service.new
	end

end
