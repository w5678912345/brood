# encoding: utf-8
# 金币产出
class OutputsController < ApplicationController
		
	def index
			@roles = Role.where("total > 0").order("total DESC").paginate(:page => params[:page], :per_page => 15)
	end

	def home
		
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
			
	end

end
