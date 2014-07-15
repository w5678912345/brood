# encoding: utf-8

class Gold::TradeController < Gold::AppController

	def show
		now = Time.now
		params[:start_time] = now.change(:hour => 0,:min => 0,:sec => 0).strftime("%Y-%m-%d %H:%M:%S") if params[:start_time].blank?
		params[:end_time] = now.since(1.day).change(:hour => 0,:min => 0,:sec => 0).strftime("%Y-%m-%d %H:%M:%S") if params[:end_time].blank?

		@payments = Payment.where(:pay_type=>"trade")
		@payments = @payments.where("created_at >= ?",params[:start_time]) unless params[:start_time].blank?
		@payments = @payments.where("created_at <= ?",params[:end_time]) unless params[:end_time].blank?
		@sum_gold = @payments.sum(:gold)
		@records  = @payments.select("server,sum(gold) as zhuanzhang").group("server") if @sum_gold>0
		
	end

	def search
	end

end
