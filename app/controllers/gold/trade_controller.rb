# encoding: utf-8
module Gold
class TradeController < AppController

	def show
		@payments = Payment.where(:pay_type=>"trade")
		@payments = @payments.where("created_at >= '#{params[:start_date]} 06:00:00'") unless params[:start_date].blank?
		@payments = @payments.where("created_at <= '#{params[:end_date]} 06:00:00'") unless params[:end_date].blank?
		@sum_gold = @payments.sum(:gold)
		@records  = @payments.select("server,sum(gold) as zhuanzhang").group("server") if @sum_gold>0
		
	end

	def search
	end

end
end