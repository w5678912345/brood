# encoding: utf-8
class NotesController < ApplicationController
	
	def index
		@notes= Note.paginate(:page => params[:page], :per_page => 10)
	end

	def home
		
	end

end