# encoding: utf-8
class Analysis::MultidayController < Analysis::AppController

	def show
		@date = Time.now - 7.day
		@end_date = Time.now

		date = params[:date] if not params[:date].blank?
		end_date = params[:end_date] if not params[:end_date].blank?
		@sevenS = Note.select("date(created_at) as Day,sum(if(api_name = 'success',1,0)) as SuccCount,
				sum(if(api_name = 'online',1,0)) as OnlineCount,
				sum(if(api_name = 'close',1,0)) as CloseCount,
				sum(if(api_name = 'AnswerVerifyCode',1,0)) as VerifyCodeCount
			").group("date(created_at)").
			time_scope(params[:date],params[:end_date])

	end


end