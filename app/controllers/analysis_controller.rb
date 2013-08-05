# encoding: utf-8
class AnalysisController < ApplicationController

	before_filter :requie_date

	def home

	end

	def index

		# @notes =  Note.time_scope(@start_time,@end_time)
		# @online_role_ids = @notes.where(:api_name => "online").select(:role_id).uniq.collect(&:role_id)
		# @success_role_ids = @notes.where(:api_name => "success").select(:role_id).uniq.collect(&:role_id)
		# @fail_role_ids = @online_role_ids - @success_role_ids
		#
		@online_note_count = @notes.where(role_id: @online_role_ids).count
		@success_note_count = @notes.where(role_id: @success_role_ids).count
		@fail_note_count = @online_note_count - @success_note_count
	end


	def roles
		@notes =  Note.time_scope(@start_time,@end_time)
		@online_role_ids = @notes.where(:api_name => "online").select(:role_id).uniq.collect(&:role_id)
		@success_role_ids = @notes.where(:api_name => "success").select(:role_id).uniq.collect(&:role_id)
		@fail_role_ids = @online_role_ids - @success_role_ids
		#return render :text => @fail_role_ids 

		@roles = Role.where(id: @online_role_ids) if params[:mark] == "online"
		@roles = Role.where(id: @success_role_ids) if params[:mark] == "success"
		@roles = Role.where(id: @fail_role_ids) if params[:mark] == "fail"
			
		#@roles = Role.where(id: @success_role_ids.collect(&:role_id))

		#@fail_count_role_ids = @online_role_ids - @success_role_ids

		@roles =  @roles.paginate(:page => params[:page], :per_page => 15)
	end

	def notes
		@notes =  Note.time_scope(@start_time,@end_time)
	end


	def online
		@notes =  Note.where("date(created_at) = ?",Date.today)
		#@notes.where(:api_name => "online").select(:role_id).uniq
		role_ids = @notes.where(:api_name => "online").select(:role_id).uniq.collect(&:role_id)
		@roles = Role.where("id in (?)",role_ids)
		render :template => 'analysis/roles'
	end



	private

	def requie_date
		@start_date = Date.today
		@start_date = Date.parse params[:date] unless params[:date].blank?
		@end_date   = @start_date + 1.day
		@date = @start_date
		#
		@start_time = Time.new(@start_date.year,@start_date.month,@start_date.day,6,0,0)
		@end_time   = @start_time+1.day #Time.new(@end_date.year,@end_date.month,@end_date.day,6,0,0)

		#

		@notes =  Note.time_scope(@start_time,@end_time)
		@online_role_ids = @notes.where(:api_name => "online").select(:role_id).uniq.collect(&:role_id)
		@success_role_ids = @notes.where(:api_name => "success").select(:role_id).uniq.collect(&:role_id)
		@fail_role_ids = @online_role_ids - @success_role_ids
	end


end