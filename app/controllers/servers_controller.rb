# encoding: utf-8
class ServersController < ApplicationController
	
	def index
		@servers = Server.all
	end

	def home

	end

	def new
		@server = Server.new
	end

	def create
		@server = Server.new(params[:server])
		if @server.save
			redirect_to servers_path
		else
			render :action => :new
		end
	end

	def edit
		@server = Server.find_by_id(params[:id])

	end

	def update
		@server = Server.find_by_id(params[:id])
		if @server.update_attributes(params[:server])
			redirect_to servers_path
		else
			render :action => :edit
		end
	end

	def destroy
		@server = Server.find_by_id(params[:id])
	end

	def roles
		@roles = Role.where(:server => params[:server]).paginate(:page => params[:page],:per_page => 10)
	end

end
