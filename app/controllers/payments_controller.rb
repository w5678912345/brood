#
class PaymentsController < ApplicationController

		def home
			@payments = Payment.total_group_role_scope
		end
		
		def index
			@payments = Payment.paginate(:page => params[:page],:per_page => 20)
		end
		
		def search
			@payments = Payment.includes(:role)
			
			@payments = @payments.where("created_at >= '#{params[:min_time]}'") unless params[:min_time].blank?
			@payments = @payments.where("created_at <= '#{params[:max_time]}'") unless params[:max_time].blank?
			@payments = @payments.where("gold >= #{params[:min_gold]}") unless params[:min_gold].blank?
			@payments = @payments.where("gold <= #{params[:max_gold]}") unless params[:max_gold].blank?
			@payments = @payments.where(:pay_type => params[:pay_type]) unless params[:pay_type].blank?
			@payments = @payments.where("remark like ?","%#{params[:remark]}%") unless params[:remark].blank?
			
			@payments = @payments.paginate(:page => params[:page],:per_page => 20)
		end
		
end
