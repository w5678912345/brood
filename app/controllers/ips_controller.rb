# encoding: utf-8
class IpsController < ApplicationController
	before_filter :set_ip

	def index
		@ips = Ip.paginate(:page => params[:page], :per_page => 10)
	end

	def show
		@ip = Ip.find_by_value(params[:id])

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

	def destroy
		@ip = Ip.find_by_value(params[:id])
		@ip.destroy
		redirect_to ips_path()
	end

	private 
	def set_ip
		params[:id] = params[:id].gsub("_",".")
	end
end