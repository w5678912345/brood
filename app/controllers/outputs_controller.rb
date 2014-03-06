# encoding: utf-8
# 金币产出
class OutputsController < ApplicationController
		
	def index
		#@roles = Role.where("total > 0").order("total DESC").paginate(:page => params[:page], :per_page => 15)
		@roles = initialize_grid(Role.where("total > 0"))
		render "wice_index"
	end

	def home
		@payments = Payment.select("pay_type,sum(gold) as zhichu").group("pay_type")
		@sum_gold = Payment.sum(:gold)
	end

	def search
		@roles = Role.where("total > 0")
		@roles = @roles.where(:id	=> params[:role_id]) unless params[:role_id].blank? 
		@roles = @roles.where(:server	=> params[:server]) unless params[:server].blank? 
		@roles = @roles.where("gold >= #{params[:min_gold]}") unless params[:min_gold].blank? 
		@roles = @roles.where("gold <= #{params[:max_gold]}") unless params[:max_gold].blank? 
		@roles = @roles.where("total_pay >= #{params[:min_pay]}") unless params[:min_pay].blank? 
		@roles = @roles.where("total_pay <= #{params[:max_pay]}") unless params[:max_pay].blank? 
		@roles = @roles.where("total >= #{params[:min_total]}") unless params[:min_total].blank? 
		@roles = @roles.where("total <= #{params[:max_total]}") unless params[:max_total].blank? 
		@roles = @roles.order(params[:order]) unless params[:order].blank?		
		@roles = @roles.paginate(:page => params[:page], :per_page => 15)
	end
		
	def histroy
			@outputs = Payment.includes(:role)
			start_time = params[:start_time].blank? ? "2013-06-01".to_date : params[:start_time].to_date
			end_time = params[:end_time].blank? ? Time.now.to_date : params[:end_time].to_date
			@outputs = @outputs.between(start_time,end_time.ago(-1.days)) if end_time >= start_time
			@outputs = @outputs.order(params[:order] || "role_id DESC")
			@outputs = @outputs.where(:role_id	=> params[:role_id]) unless params[:role_id].blank? 
			@outputs = @outputs.select("role_id,max(total) as max_total,min(total) as min_total").group("role_id")
			@sum_max_total =(@outputs.collect &:max_total).sum
			@sum_min_total =(@outputs.collect &:min_total).sum
			@outputs = @outputs.paginate(:page => params[:page],:per_page => 10)
	end

end
