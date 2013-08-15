class TestsController < ApplicationController
	
	def index
		@servers=  Server.all
	end

	def show
	end

	def edit
	end

end