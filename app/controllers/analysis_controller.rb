# encoding: utf-8
class AnalysisController < ApplicationController

	before_filter :requie_date

	def home

	end

	def one_day
		
	end

	def online
		
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

	def index
		@online_note_count = @notes.where(role_id: @online_role_ids).count
		@success_note_count = @notes.where(role_id: @success_role_ids).count
		@fail_note_count = @online_note_count - @success_note_count
	end


	def roles
		# @notes =  Note.time_scope(@start_time,@end_time)
		# @online_role_ids = @notes.where(:api_name => "online").select(:role_id).uniq.collect(&:role_id)
		# @success_role_ids = @notes.where(:api_name => "success").select(:role_id).uniq.collect(&:role_id)
		# @fail_role_ids = @online_role_ids - @success_role_ids
		#return render :text => @fail_role_ids 

		@roles = Role.where(id: @online_role_ids) if params[:mark] == "online"
		@roles = Role.where(id: @success_role_ids) if params[:mark] == "success"
		@roles = Role.where(id: @fail_role_ids) if params[:mark] == "fail"
			
		#@roles = Role.where(id: @success_role_ids.collect(&:role_id))

		#@fail_count_role_ids = @online_role_ids - @success_role_ids

		@roles =  @roles.paginate(:page => params[:page], :per_page => 20)
	end

	def notes
		# @notes =  Note.time_scope(@start_time,@end_time) #.includes(:computer,:role)
		# @success_notes = @notes.where(role_id: @success_role_ids).select("api_name,count(id) as ecount").group("api_name").order("api_name asc")
		# @fail_notes = @notes.where(role_id: @fail_role_ids).select("api_name,count(id) as ecount").group("api_name").order("api_name asc") 

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

	def test
		#Note.select("api_name,count(id)").where(role_id: Note.select("role_id").where("api_name=?","success")).group("api_name")
		notes = @notes

		@online_notes = notes.where(:role_id => notes.where(:api_name => "online").select("role_id").uniq)
		@success_notes = @online_notes.where(:role_id => notes.where(:api_name => "success").select("role_id").uniq)
		@fail_notes =  @online_notes.where("role_id not in (?)",@success_notes.select("role_id").uniq.map(&:role_id))

		#
		# @on_role_ids = notes.where(:api_name => "online").select("role_id").uniq
		# # success roles
		# @su_role_ids = notes.where(:api_name => "success").where(:role_id => notes.where(:api_name=>"online").select("role_id").uniq) #.select("role_id")
		# # fail roles
		# @fa_role_ids = notes.where(:api_name => "online").where("role_id not in (?)",notes.where(:api_name=>"success").select("role_id").uniq.map(&:role_id)).select("role_id")
		#
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