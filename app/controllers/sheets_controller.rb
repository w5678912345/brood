# encoding: utf-8
class SheetsController < ApplicationController
	

	def index
		@sheet = Sheet.new
		@sheets= Sheet.paginate(:page => params[:page], :per_page => 10)
	end

	def new
	end

	def create
		@sheet = Sheet.new(params[:sheet])
		@sheet.uploader_id = current_user.id
		@sheet.save
		redirect_to sheets_path()
	end

	def import
		@sheet = Sheet.find_by_id(params[:id])
		return unless @sheet
		@sheet.importer_id = current_user.id
		@sheet.import

		redirect_to sheets_path()
	end

	def destroy
		@sheet = Sheet.find_by_id(params[:id])
		@sheet.destroy if @sheet
		redirect_to sheets_path()
	end


end