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
		@notes = @notes.where("created_at >= '#{params[:min_time]} 06:00:00'") unless params[:min_time].blank?
		@notes = @notes.where("created_at <= '#{params[:max_time]} 06:00:00'") unless params[:max_time].blank?
		@notes = @notes.where(:api_code => params[:code]) unless params[:code].blank?
		per_page = params[:per_page].blank? ? 20 : params[:per_page].to_i
		@notes = @notes.paginate(:page => params[:page], :per_page => per_page)
	end

	def list

	end

	def count
		
	end

end
