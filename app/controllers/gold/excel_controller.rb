# encoding: utf-8

class Gold::ExcelController <Gold::AppController

	def show
		now = Time.now.since(1.days)
		params[:start_time] = now.ago(7.day).change(:hour => 0,:min => 0,:sec => 0).strftime("%Y-%m-%d %H:%M:%S") if params[:start_time].blank?
		params[:end_time] = now.change(:hour => 0,:min => 0,:sec => 0).strftime("%Y-%m-%d %H:%M:%S") if params[:end_time].blank?
			
		@records = Payment.real_pay.select("date(created_at) as Day,sum(gold) Gold")
		@records = @records.where("server like ?","#{params[:server]}%") unless params[:server].blank?
		@records = @records.group("Day").time_scope(params[:start_time],params[:end_time]).order("Day")

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
