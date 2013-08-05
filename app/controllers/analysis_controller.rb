# encoding: utf-8
class AnalysisController < ApplicationController

	before_filter :requie_date

	def index
		#render :text => params[:date]
		
		#
		@notes =  Note.time_scope(@start_time,@end_time)
		@online_role_ids = @notes.where(:api_name => "online").select(:role_id).uniq
		@success_role_ids = @notes.where(:api_name => "success").select(:role_id).uniq
		@fail_count_role_ids = @online_role_ids - @success_role_ids
		#
		@online_role_count = @online_role_ids.count #@notes.where(:api_name => "online").select(:role_id).uniq.count
		@success_role_count = @success_role_ids.count  #@notes.where(:api_name => "success").select(:role_id).uniq.count
		@fail_role_count = @online_role_count - @success_role_count

		@online_note_count = @notes.where(role_id: @online_role_ids.collect(&:role_id)).count
		@success_note_count = @notes.where(role_id: @success_role_ids.collect(&:role_id)).count
		@fail_note_count = @online_note_count - @success_note_count
		#@notes = @notes.where(:api_name => "online").includes(:role).paginate(:page => params[:page], :per_page => 10)
	end


	def by
		#render :text => params[:date]
		date = Date.today
		date = Date.parse params[:date] unless params[:date].blank?
		@notes =  Note.where("date(created_at) = ?", date)
		@online_count = @notes.where(:api_name => "online").select(:role_id).uniq.count
		@success_count = @notes.where(:api_name => "success").select(:role_id).uniq.count
		@fail_count = @online_count - @success_count
		@notes = @notes.where(:api_name => "online").includes(:role).paginate(:page => params[:page], :per_page => 10)
		render :template => 'analysis/index'
	end

	def home

	end

	def role

	end

	def today

		# @notes = Note.where("date(created_at) = ?",Date.today)
		# @online_notes = @notes.where(:api_name => "online")

		# @all_count = @notes.count
		@notes =  Note.where("date(created_at) = ?",Date.today)
		@online_count = @notes.where(:api_name => "online").select(:role_id).uniq.count
		@success_count = @notes.where(:api_name => "success").select(:role_id).uniq.count
		@fail_count = @online_count - @success_count
		@notes = @notes.where(:api_name => "online").includes(:role).paginate(:page => params[:page], :per_page => 10)
	end

	def online
		@notes =  Note.where("date(created_at) = ?",Date.today)
		#@notes.where(:api_name => "online").select(:role_id).uniq
		role_ids = @notes.where(:api_name => "online").select(:role_id).uniq.collect(&:role_id)
		@roles = Role.where("id in (?)",role_ids)
		render :template => 'analysis/roles'
	end

	def roles

	end


	private

	def requie_date
		@start_date = Date.today
		@start_date = Date.parse params[:date] unless params[:date].blank?
		@end_date   = @start_date + 1.day
		#
		@start_time = Time.new(@start_date.year,@start_date.month,@start_date.day,6,0,0)
		@end_time   = @start_time+1.day #Time.new(@end_date.year,@end_date.month,@end_date.day,6,0,0)
	end


end