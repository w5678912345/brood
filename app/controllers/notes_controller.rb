# encoding: utf-8
class NotesController < ApplicationController
	
	def index
		@notes= Note.includes(:computer,:role).paginate(:page => params[:page], :per_page => 20)
	end

	def home
		
	end

	def search
		@notes = Note.includes(:computer,:role)
		@notes = @notes.where(:role_id => params[:role_id]) unless params[:role_id].blank?
		@notes = @notes.where("api_name like ?","%#{params[:event]}%") unless params[:event].blank?
		@notes = @notes.where("msg like ?","%#{params[:msg]}%") unless params[:msg].blank?
		@notes = @notes.where("created_at >= '#{params[:min_time]}'") unless params[:min_time].blank?
		@notes = @notes.where("created_at <= '#{params[:max_time]}'") unless params[:max_time].blank?
		@notes = @notes.where(:api_code => params[:code]) unless params[:code].blank?
		per_page = params[:per_page].blank? ? 20 : params[:per_page].to_i
		@notes = @notes.paginate(:page => params[:page], :per_page => per_page)
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
