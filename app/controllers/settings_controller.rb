# encoding: utf-8
class SettingsController < ApplicationController
	
	def index
		@setting = Setting.new
		@settings = Setting.paginate(:page => params[:page], :per_page => 10)
	end

	def create
		@setting = Setting.new(params[:setting])
		@setting.save
		redirect_to settings_path
	end

	def edit
		@setting = Setting.find_by_id(params[:id])
	end

	def update
		@setting =Setting.find_by_id(params[:id])
		@setting.update_attributes(params[:setting])
		redirect_to settings_path
	end

	def destroy
		@setting =Setting.find_by_id(params[:id])
		@setting.destroy if @setting
		redirect_to settings_path
	end



end