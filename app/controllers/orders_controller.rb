# encoding: utf-8
class OrdersController < ApplicationController

	def index
		@orders = Order.where("id>0")
		per_page = params[:per_page].blank? ? 20 : params[:per_page].to_i
		@orders = @orders.paginate(:page => params[:page], :per_page => per_page)
	end

	
end