# encoding: utf-8
# @suxu
# 
class Api::OrdersController < Api::BaseController
	
	# def pull
	# 	@phone_machine = PhoneMachine.find_by_name(params[:name])

	# 	@orders = Order.joins(:phone).where(:pulled=>false).readonly(false)
	# 	phone_no = @orders.map(&:phone_no)
	# 	# @orders.each do |order|
	# 	# 	phone_no << order.phone_no
	# 	# end
	# 	@orders.update_all(:pulled=>true,:pulled_at=>Time.now)
	# 	render :json=>{:phone_no=>phone_no}
	# end

	def sub
		@account = Account.find_by_no(params[:id] || params[:account_id])
		return render :json=>{:code=>CODES[:not_find_account]} unless @account
		return render :json=>{:code=>CODES[:not_bind_phone]} unless @account.is_bind_phone
		@order =  Order.create(:phone_no=>@account.phone_id,:account_no=>@account.no,:trigger_event=>params[:event],:sms=>params[:sms])
		if @order
			render :json => {:code=>1,:data=>{:id=>@order.id,:finished=>@order.finished,:event=>@order.trigger_event,:link_status=>@order.link.status}}
		end
	end

	def show
		@order = Order.find_by_id(params[:id])
		return render :json=>{:code=>CODES[:not_fint_order],:msg=>"not find order"} unless @order
		render :json => {:code=>1,:data=>{:id=>@order.id,:finished=>@order.finished,:event=>@order.trigger_event,:link_status=>@order.link.status}}
	end

	def get
		@order = Order.joins(:link).where(:finished=>false).where("links.status=?","sent").find_by_id(params[:id])
		return render :json=>{:code=>CODES[:not_fint_order]} unless @order
		render :json=>{:code=>1,:order_id=>@order.id}
	end

	def end
		@order = Order.where(:finished=>false).find_by_id(params[:id])
		return render :json=>{:code=>CODES[:not_fint_order]} unless @order
		@order.update_attributes(:finished=>true,:finished_at=>Time.now,:result=>params[:result],:msg=>params[:msg])
		@order.link.update_attributes(:status=>"idle") if @order.link
		render :json => {:code=>1}
	end



end