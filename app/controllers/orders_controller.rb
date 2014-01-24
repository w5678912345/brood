# encoding: utf-8
class OrdersController < ApplicationController

	def index
		@orders = Order.search(params)
		per_page = params[:per_page].blank? ? 20 : params[:per_page].to_i
		@orders = @orders.paginate(:page => params[:page], :per_page => per_page)
	end


	def checked
		@ids = params[:ids] || []
  	end

  	def do_checked
    	@ids = params[:ids]
    	@do = params[:do]
    	@orders = Order.where("id in (?)",@ids)
    	if @do == "finish"
    		i = @orders.where(:finished=>false).update_all(:finished=>true,:finished_at=>Time.now,:updated_at=>Time.now,:msg=>"click")
    		@orders.each do |order|
                order.link.update_attributes(:status=>"idle") if order.link
            end
            flash[:msg] = "#{i}个工单被结束了"
    	else
    		flash[:msg] = "没有任何操作"
    	end
	end
	
end