# encoding: utf-8
class NotesController < ApplicationController
	
	def index
		now = Time.now
		params[:start_time] = now.change(:hour => 0,:min => 0,:sec => 0).strftime("%Y-%m-%d %H:%M:%S") if params[:start_time].blank?
		params[:end_time] = now.since(1.day).change(:hour => 0,:min => 0,:sec => 0).strftime("%Y-%m-%d %H:%M:%S") if params[:end_time].blank?
		@notes = Note.list_search(params)
		#per_page = params[:per_page].blank? ? 20 : params[:per_page].to_i
		#@notes = @notes.paginate(:page => params[:page], :per_page => per_page)
		@notes = initialize_grid(@notes)
		render "wice_index"
	end

	def analysis
		@start_date = Time.now - 7.day 
		@end_date = Time.now + 1.day
		@start_date = params[:start_date] unless params[:start_date].blank?
		@end_date = params[:end_date]  unless params[:end_date].blank?
		@tmp_notes = Note.select("date(created_at) as date,
			sum(if(api_name='computer_start',1,0)) as computer_start,
			sum(if(api_name='not_find_account',1,0)) as computer_no_acount,
			sum(if(api_name='computer_start',hours,0)) as computer_sum_hours,
			sum(if(api_name='account_start',1,0)) as account_start,
			sum(if(api_name='account_start' and success=1,1,0)) as account_success,
			sum(if(api_name='disconnect',1,0)) as disconnect,
			sum(if(api_name='exception',1,0)) as exception,
			sum(if(api_name='role_online',1,0)) as role_online,
			sum(if(api_name='role_start',1,0)) as role_start,
			sum(if(api_name='disable',1,0)) as disable,
			sum(if(api_name='role_start' and success = 1,1,0)) as role_success
			").group("date(created_at)").date_scope(@start_date,@end_date).reorder("date(created_at) desc")
	end

	# select count(id),date(created_at) as day,api_name from notes group by date(created_at),api_name;
	def group_count
		@notes = Note.list_search(params)
		@tmp_notes = @notes.select("count(id) as ncount,api_name").group("api_name").reorder("api_name")
	end




end
