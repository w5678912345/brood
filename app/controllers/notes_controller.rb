# encoding: utf-8
class NotesController < ApplicationController
	
	def index
		@notes = Note.where("id>0")
		@notes = @notes.where(:role_id => params[:role_id]) unless params[:role_id].blank?
		@notes = @notes.where(:session_id => params[:session_id]) unless params[:session_id].blank?
		@notes = @notes.where(:account => params[:account]) unless params[:account].blank?
		@notes = @notes.where(:server => params[:server]) unless params[:server].blank?
		@notes = @notes.where(:computer_id => params[:cid]) unless params[:cid].blank?
		@notes = @notes.where(:api_name => params[:api_name]) unless params[:api_name].blank?
		@notes = @notes.where(:api_name => params[:event]) unless params[:event].blank?
		@notes = @notes.where("ip like ?","%#{params[:ip]}%") unless params[:ip].blank?
		@notes = @notes.where("msg like ?","%#{params[:msg]}%") unless params[:msg].blank?
		@notes = @notes.where("date(created_at) = ?",params[:date]) unless params[:date].blank?
		@notes = @notes.where("created_at >= '#{params[:start_date]} 06:00:00'") unless params[:start_date].blank?
		@notes = @notes.where("created_at <= '#{params[:end_date]} 06:00:00'") unless params[:end_date].blank?
		@notes = @notes.where(:api_code => params[:code]) unless params[:code].blank?
		@notes = @notes.where(:version => params[:version]) unless params[:version].blank?
		per_page = params[:per_page].blank? ? 20 : params[:per_page].to_i
		@notes = @notes.paginate(:page => params[:page], :per_page => per_page)
	end

	def analysis
		@start_date = Time.now - 7.day 
		@end_date = Time.now + 1.day
		@start_date = params[:start_date] unless params[:start_date].blank?
		@end_date = params[:end_date]  unless params[:end_date].blank?
		@tmp_notes = Note.select("date(created_at) as date,
			sum(if(api_name='computer_start',1,0)) as computer_start,
			sum(if(api_name='not_find_account',1,0)) as computer_no_acount,
			sum(if(api_name='account_start',1,0)) as account_start,
			sum(if(api_name='role_dispatch',1,0)) as role_dispatch,
			sum(if(api_name='role_start',1,0)) as role_start,
			sum(if(api_name='account_success',1,0)) as account_success,
			sum(if(api_name='role_success',1,0)) as role_success
			").group("date(created_at)").date_scope(@start_date,@end_date).reorder("date(created_at) desc")
	end




end
