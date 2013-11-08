# encoding: utf-8
class NotesController < ApplicationController
	
	def index
		@notes = Note.list_search(params)
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
			sum(if(api_name='account_success',1,0)) as account_success,
			sum(if(api_name='disconnect',1,0)) as disconnect,
			sum(if(api_name='exception',1,0)) as exception,
			sum(if(api_name='role_dispatch',1,0)) as role_dispatch,
			sum(if(api_name='role_start',1,0)) as role_start,
			sum(if(api_name='disable',1,0)) as disable,
			sum(if(api_name='role_success',1,0)) as role_success
			").group("date(created_at)").date_scope(@start_date,@end_date).reorder("date(created_at) desc")
	end

	def group_count
		@start_date = Time.now - 1.day 
		@end_date = Time.now + 1.day
		@start_date = params[:start_date] unless params[:start_date].blank?
		@end_date = params[:end_date]  unless params[:end_date].blank?
		# select count(id),date(created_at) as day,api_name from notes group by date(created_at),api_name;
		@tmp_notes = Note.select("count(id) as ncount ,date(created_at) as day,api_name")
		.group("date(created_at),api_name").time_scope(@start_date,@end_date).reorder("date(created_at) desc")
	end




end
