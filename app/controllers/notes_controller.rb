# encoding: utf-8
class NotesController < ApplicationController
	
	def index
		@notes= Note.includes(:computer,:role).paginate(:page => params[:page], :per_page => 20)
	end

	def home
		
	end

	def search
		@notes = Note.includes(:computer,:role)
		@notes = @notes.where(:api_name => params[:event]) unless params[:event].blank?
		@notes = @notes.where("created_at >= '#{params[:min_time]}'") unless params[:min_time].blank?
		@notes = @notes.where("created_at <= '#{params[:max_time]}'") unless params[:max_time].blank?
		@notes = @notes.paginate(:page => params[:page], :per_page => 20)
	end

	def online
		@notes = Note.online_scope.includes(:computer,:role).paginate(:page => params[:page], :per_page => 20)
		@list_title = "Online Notes"
		render :template => 'roles/index'
	end

	def offline
		@notes = Note.offline_scope.includes(:computer,:role).paginate(:page => params[:page], :per_page => 20)
		@list_title = "Offline Notes"
		render :template => 'roles/index'
	end

	def sync
		@notes = Note.sync_scope.includes(:computer,:role).paginate(:page => params[:page], :per_page => 20)
		@list_title = "Sync Notes"
		render :template => 'roles/index'
	end

	def close
		@notes = Note.close_scope.includes(:computer,:role).paginate(:page => params[:page], :per_page => 20)
		@list_title = "Close Notes"
		render :template => 'roles/index'
	end

	def reg
		@notes = Note.reg_scope.includes(:computer,:role).paginate(:page => params[:page], :per_page => 20)
		@list_title = "reg Notes"
		render :template => 'roles/index'
	end

end