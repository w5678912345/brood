#
class PaymentsController < ApplicationController

		def home
			#@payments = Payment.total_group_role_scope
			@payments = Payment.select("pay_type,sum(gold) as zhichu").group("pay_type")
			@sum_gold = Payment.sum(:gold)
		end
		
		def index
			now = Time.now
			params[:start_time] = now.change(:hour => 0,:min => 0,:sec => 0).strftime("%Y-%m-%d %H:%M:%S") if params[:start_time].blank?
			params[:end_time] = now.since(1.day).change(:hour => 0,:min => 0,:sec => 0).strftime("%Y-%m-%d %H:%M:%S") if params[:end_time].blank?

			@payments = Payment.includes(:role).order("id DESC")
			@payments = @payments.where(:role_id => params[:role_id]) unless params[:role_id].blank?
			@payments = @payments.where("created_at >= ?",params[:start_time]) unless params[:start_time].blank?
			@payments = @payments.where("created_at <= ?",params[:end_time]) unless params[:end_time].blank?
			@payments = @payments.where("gold >= #{params[:min_gold]}") unless params[:min_gold].blank?
			@payments = @payments.where("gold <= #{params[:max_gold]}") unless params[:max_gold].blank?
			@payments = @payments.where("server like ?","%#{params[:server]}%") unless params[:server].blank?
			@payments = @payments.where(:pay_type => params[:pay_type]) unless params[:pay_type].blank?
			@payments = @payments.where("remark like ?","%#{params[:remark]}%") unless params[:remark].blank?
			@sum_gold = @payments.sum(:gold)
			#@payments = @payments.paginate(:page => params[:page],:per_page => 20)
			@payments = initialize_grid(@payments)
			render "wice_index"
		end
		
		def search
			@payments = Payment.includes(:role).order("id DESC")
			@payments = @payments.where(:role_id => params[:role_id]) unless params[:role_id].blank?
			@payments = @payments.where("created_at >= '#{params[:min_time]}'") unless params[:min_time].blank?
			@payments = @payments.where("created_at <= '#{params[:max_time]}'") unless params[:max_time].blank?
			@payments = @payments.where("gold >= #{params[:min_gold]}") unless params[:min_gold].blank?
			@payments = @payments.where("gold <= #{params[:max_gold]}") unless params[:max_gold].blank?
			@payments = @payments.where(:server => params[:server]) unless params[:server].blank?
			@payments = @payments.where(:pay_type => params[:pay_type]) unless params[:pay_type].blank?
			@payments = @payments.where("remark like ?","%#{params[:remark]}%") unless params[:remark].blank?
			
			@payments = @payments.paginate(:page => params[:page],:per_page => 20)
		end

		def roles
				@payments = Payment.includes(:role).select("sum(gold) as sum_gold,role_id").group(:role_id)
				@payments = @payments.paginate(:page => params[:page],:per_page => 20)
		end
		
end
