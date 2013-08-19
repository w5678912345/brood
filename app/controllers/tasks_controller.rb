class TasksController < ApplicationController

	def index
		@tasks = Task.includes(:computer,:role)
		@tasks = @tasks.where(:pushed=> params[:pushed]) unless params[:pushed].blank?
		@tasks = @tasks.where(:callback=> params[:callback]) unless params[:callback].blank?
		@tasks = @tasks.where(:success=> params[:success]) unless params[:success].blank?
		@tasks = @tasks.where(:sup_id=> params[:sup_id]) unless params[:sup_id].blank?
		@tasks = @tasks.where("name like ?","%#{params[:name]}%") unless params[:name].blank?
		@tasks = @tasks.where("command like ?","%#{params[:command]}%") unless params[:command].blank?
		per_page = params[:per_page].blank? ? 20 : params[:per_page].to_i
		@tasks = @tasks.paginate(:page => params[:page], :per_page => per_page)
	end

	def list
		
	end

	def new
		@task = Task.new
	end

	def create
		@task = Task.new(params[:task])
		@task.user_id = current_user.id
		if @task.save
			redirect_to tasks_path
		else
			render :action => :new
		end
	end

	def show
		@task = Task.find_by_id(params[:id])
	end

	def pre
		@task = Task.find_by_id(params[:id])
		@cids = session[:cids] 
		@rids = session[:rids] if @cids.blank? || @cids.any?
	end

	def confirm
		@task = Task.find_by_id(params[:id])
		@cids = session[:cids]
		@rids = session[:rids]
		if @cids && @cids.any?
			@cids.each do |cid|
				task = @task.new_by_computer cid,current_user.id
				task.save
			end
		elsif @rids && @rids.any?
			@rids.each do |rid|
				task = @task.new_by_role rid,current_user.id
				task.save
			end
		end
		session[:cids] = nil
		session[:rids] = nil
		redirect_to tasks_path
	end

	def edit
		@task = Task.find_by_id(params[:id])
	end

	def update
		@task = Task.find_by_id(params[:id])
		if @task.update_attributes(params[:task])
			redirect_to tasks_path
		else
			render :action => :edit
		end
	end


	def destroy
		@task = Task.find_by_id(params[:id])
		@task.destroy if @task
		redirect_to tasks_path
	end




end