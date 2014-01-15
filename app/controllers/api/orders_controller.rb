# encoding: utf-8
# @suxu
# 
class Api::OrdersController < Api::BaseController
	
	def pull
		@phone_machine = PhoneMachine.find_by_name(params[:name])

		@orders = Order.joins(:phone).where(:pulled=>false).readonly(false)
		phone_no = @orders.map(&:phone_no)
		# @orders.each do |order|
		# 	phone_no << order.phone_no
		# end
		@orders.update_all(:pulled=>true,:pulled_at=>Time.now)
		render :json=>{:phone_no=>phone_no}
	end

	def query

	end


end