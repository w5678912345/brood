# encoding: utf-8
class Analysis::NoteController < Analysis::AppController


	def show
		@start_date = Time.now - 1.day 
		@end_date = Time.now + 1.day
		@start_date = params[:start_date] unless params[:start_date].blank?
		@end_date = params[:end_date]  unless params[:end_date].blank?
		# select count(id),date(created_at) as day,api_name from notes group by date(created_at),api_name;
		@tmp_notes = Note.select("count(id) as ncount ,date(created_at) as day,api_name")
		.group("date(created_at),api_name").time_scope(@start_date,@end_date).reorder("date(created_at) desc")

	end

end