# encoding: utf-8
module Gold
class ExcelController < AppController

	def show
		now = Time.now
		params[:start_time] = now.ago(7.day).change(:hour => 0,:min => 0,:sec => 0).strftime("%Y-%m-%d %H:%M:%S") if params[:start_time].blank?
		params[:end_time] = now.change(:hour => 0,:min => 0,:sec => 0).strftime("%Y-%m-%d %H:%M:%S") if params[:end_time].blank?
			
		@records = Payment.select("date(created_at) as Day,sum(gold) Gold").trade_scope
		@records = @records.where("server like ?","#{params[:server]}%") unless params[:server].blank?
		@records = @records.group("date(created_at)").time_scope(params[:start_time],params[:end_time]).order("date(created_at)")

	end

end
end