# encoding: utf-8
class Analysis::OnedayController < Analysis::AppController

	before_filter :set_date

	def show
		notes = @notes

		@online_notes = notes.where(:role_id => notes.where(:api_name => "online").select("role_id").uniq)
		@success_notes = @online_notes.where(:role_id => notes.where(:api_name => "success").select("role_id").uniq)
		@fail_notes =  @online_notes.where("role_id not in (?)",@success_notes.select("role_id").uniq.map(&:role_id))

		#
		@online_group_notes = @online_notes.select("api_name,count(id) as ecount").group("api_name").reorder("api_name asc")
		@success_group_notes = @success_notes.select("api_name,count(id) as ecount").group("api_name").reorder("api_name asc")
		@fail_group_notes = @fail_notes.select("api_name,count(id) as ecount").group("api_name").reorder("api_name asc")
		
		@success_hash = Hash.new
		@success_group_notes.each do |note|
			@success_hash[note.api_name] = note.ecount
		end
		@fail_hash = Hash.new
		@fail_group_notes.each do |note|
			@fail_hash[note.api_name] = note.ecount
		end
	end


	def roles

		@roles = Role.where(id: @online_role_ids) if params[:mark] == "online"
		@roles = Role.where(id: @success_role_ids) if params[:mark] == "success"
		@roles = Role.where(id: @fail_role_ids) if params[:mark] == "fail"
			
		#@roles = Role.where(id: @success_role_ids.collect(&:role_id))

		#@fail_count_role_ids = @online_role_ids - @success_role_ids

		@roles =  @roles.paginate(:page => params[:page], :per_page => 20)

	end

	private 

	def set_date
		@date = Date.today
		@date = Date.parse params[:date] unless params[:date].blank?
		@start_time = Time.new(@date.year,@date.month,@date.day,6,0,0)
		@end_time   = @start_time+1.day #Time.new(@end_date.year,@end_date.month,@end_date.day,6,0,0)

		#

		@notes =  Note.time_scope(@start_time,@end_time)
		@online_role_ids = @notes.where(:api_name => "online").select(:role_id).uniq.collect(&:role_id)
		@success_role_ids = @notes.where(:api_name => "success").select(:role_id).uniq.collect(&:role_id)
		@fail_role_ids = @online_role_ids - @success_role_ids
	end

	def hello

	end

	def hello

	end
	
end