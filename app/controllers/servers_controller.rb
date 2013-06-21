# encoding: utf-8
class ServersController < ApplicationController
	
	def index
		
	end

	def home

	end

	def roles
			@roles = Role.where(:server => params[:server]).paginate(:page => params[:page],:per_page => 10)
	end

end
