# encoding: utf-8
class Analysis::MultidayController < Analysis::AppController

	def show
		@start_time = Time.now - 7.day
		@end_time = Time.now + 1.day

		@start_time = params[:date] if not params[:date].blank?
		@end_time = params[:end_date] if not params[:end_date].blank?

		@sevenS = Note.select("date(created_at) as Day,sum(if(api_name = 'success',1,0)) as SuccCount,
				sum(if(api_name = 'online',1,0)) as OnlineCount,
				sum(if(api_name = 'close',1,0)) as CloseCount,
				sum(if(api_name = 'AnswerVerifyCode',1,0)) as VerifyCodeCount
			").group("date(created_at)").
			time_scope(@start_time,@end_time).order("date(created_at)")
		
		tradetemp = Payment.select("date(created_at) as Day,sum(gold) Gold").group("date(created_at)").
						time_scope(@start_time,@end_time).order("date(created_at)")
		@trade = {}
		@tradesum = 0
		tradetemp.each do |i|
			@trade[i.Day] = i.Gold
			@tradesum += i.Gold
		end
	end


end