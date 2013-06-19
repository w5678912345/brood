# encoding: utf-8
class IpsController < ApplicationController
	before_filter :set_ip

	def index
		@ips = Ip.paginate(:page => params[:page], :per_page => 10)
	end

	def show
		@ip = Ip.find_by_value(params[:id])
	end

	def roles
		@ip = Ip.find_by_value(params[:id])
		@roles = Role.where(:ip => @ip.value).paginate(:page => params[:page], :per_page => 10)
		@page_params = { :controller => "ips", :action => "roles",:id=>@ip.ip_url }
	end

	def notes
		@ip = Ip.find_by_value(params[:id])
		@notes = Note.where(:ip => @ip.value).paginate(:page => params[:page], :per_page => 10)
		@page_params = { :controller => "ips", :action => "notes",:id=>@ip.ip_url }
	end

	def clear
		@ip = Ip.find_by_value(params[:id]) if params[:id]
		if @ip
			 @ip.destroy
		else
			Ip.destroy_all
		end
		redirect_to ips_path
	end

	def reset
		Ip.reset_use_count
		redirect_to ips_path
	end

	def destroy
		@ip = Ip.find_by_value(params[:id])
		@ip.destroy
		redirect_to ips_path()
	end

	private 
	def set_ip
		params[:id] = params[:id].gsub("_",".") if params[:id]
	end
end
