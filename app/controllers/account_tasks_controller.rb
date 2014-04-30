# encoding: utf-8
class AccountTasksController < ApplicationController

	def index
		@records = AccountTask.order("id desc")
		@records = @records.where("account = ?",params[:no]) unless params[:no].blank?
		@records = @records.where("event = ?",params[:event]) unless params[:event].blank?
		@records = @records.where("status = ?",params[:status]) unless params[:status].blank?
		@records = initialize_grid(@records,:per_page=>20)
	end

end