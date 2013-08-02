# encoding: utf-8
class AnalysisController < ApplicationController


	def index
		#render :text => params[:date]
		date = Date.today
		date = Date.parse params[:date] unless params[:date].blank?
		@notes =  Note.where("date(created_at) = ?", date)
		@online_count = @notes.where(:api_name => "online").select(:role_id).uniq.count
		@success_count = @notes.where(:api_name => "success").select(:role_id).uniq.count
		@fail_count = @online_count - @success_count
		@notes = @notes.where(:api_name => "online").includes(:role).paginate(:page => params[:page], :per_page => 10)
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


end