# encoding: utf-8
class NotesController < ApplicationController
	
	def index
		@notes = Note.where("id>0")
		@notes = @notes.where(:role_id => params[:role_id]) unless params[:role_id].blank?
		@notes = @notes.where(:account => params[:account]) unless params[:account].blank?
		@notes = @notes.where(:server => params[:server]) unless params[:server].blank?
		@notes = @notes.where(:computer_id => params[:cid]) unless params[:cid].blank?
		@notes = @notes.where(:api_name => params[:api_name]) unless params[:api_name].blank?
		@notes = @notes.where("api_name like ?","%#{params[:event]}%") unless params[:event].blank?
		@notes = @notes.where("ip like ?","%#{params[:ip]}%") unless params[:ip].blank?
		@notes = @notes.where("msg like ?","%#{params[:msg]}%") unless params[:msg].blank?
		@notes = @notes.where("created_at >= '#{params[:min_time]} 06:00:00'") unless params[:min_time].blank?
		@notes = @notes.where("created_at <= '#{params[:max_time]} 06:00:00'") unless params[:max_time].blank?
		@notes = @notes.where(:api_code => params[:code]) unless params[:code].blank?
		@notes = @notes.where(:version => params[:version]) unless params[:version].blank?
		per_page = params[:per_page].blank? ? 20 : params[:per_page].to_i
		@notes = @notes.paginate(:page => params[:page], :per_page => per_page)
	end


end
