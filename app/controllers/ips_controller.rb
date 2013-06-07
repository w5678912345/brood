# encoding: utf-8
class IpsController < ApplicationController
	
	def index
		@ips = Ip.paginate(:page => params[:page], :per_page => 10)
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
end