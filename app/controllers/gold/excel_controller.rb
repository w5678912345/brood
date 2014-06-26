# encoding: utf-8

class Gold::ExcelController <Gold::AppController

	def show
		now = Time.now
		params[:start_time] = now.ago(7.day).change(:hour => 0,:min => 0,:sec => 0).strftime("%Y-%m-%d %H:%M:%S") if params[:start_time].blank?
		params[:end_time] = now.change(:hour => 0,:min => 0,:sec => 0).strftime("%Y-%m-%d %H:%M:%S") if params[:end_time].blank?
			
		@records = Payment.select("date(created_at) as Day,sum(gold) Gold").trade_scope
		@records = @records.where("server like ?","#{params[:server]}%") unless params[:server].blank?
		@records = @records.group("date(created_at)").time_scope(params[:start_time],params[:end_time]).order("date(created_at)")

		@trade = {}
		@tradesum = 0
		@records.each do |i|
			@trade[i.Day.to_s] = i.Gold
			@tradesum += i.Gold
		end

		start_time  = Date.parse(params[:start_time])
		end_time = Date.parse(params[:end_time])

		@dates = (start_time..end_time).to_a
		
	end

end
