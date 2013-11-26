# encoding: utf-8
class Analysis::EverydayController < Analysis::AppController

	def show
		@start_date = Date.today - 7.day 
		@end_date = Date.today + 1.day
		@start_date = params[:start_date] unless params[:start_date].blank?
		@end_date = params[:end_date]  unless params[:end_date].blank?
		@tmp_notes = Note.select("date(created_at) as date,
			sum(if(api_name='computer_start',1,0)) as computer_start,
			sum(if(api_name='computer_start',hours,0)) as computer_sum_hours,
			sum(if(api_name='account_start',1,0)) as account_start,
			sum(if(api_name='account_start' and success=1,1,0)) as account_success,
			sum(if(api_name='account_start',hours,0)) as account_sum_hours,
			sum(if(api_name='role_online',1,0)) as role_online,
			sum(if(api_name='role_start',1,0)) as role_start,
			sum(if(api_name='role_start' and success = 1,1,0)) as role_success,
			sum(if(api_name='role_start',hours,0)) as role_sum_hours,
			sum(if(api_name='role_start' and success = 1,hours,0)) as role_success_sum_hours,
			COUNT(DISTINCT if(api_name='computer_start',computer_id,null)) as computer_start_count,
			COUNT(DISTINCT if(api_name='account_start',account,null)) as account_start_count,
			COUNT(DISTINCT if(api_name='account_start' and success = 1, account, null)) as account_success_count,
			COUNT(DISTINCT if(api_name='role_online',role_id,null)) as role_online_count,
			COUNT(DISTINCT if(api_name='role_start',role_id,null)) as role_start_count,
			COUNT(DISTINCT if(api_name='role_start' and success = 1, role_id, null)) as role_success_count
			")
		@tmp_notes = @tmp_notes.where(:server=>params[:server]) unless params[:server].blank?
		@tmp_notes = @tmp_notes.group("date(created_at)").date_scope(@start_date,@end_date).reorder("date(created_at) desc")
		#
		tradetemp = Payment.select("date(created_at) as Day,sum(gold) Gold").trade_scope.group("date(created_at)").
						time_scope(@start_date,@end_date).order("date(created_at)")
		@trade = {}
		@tradesum = 0
		tradetemp.each do |i|
			@trade[i.Day] = i.Gold
			@tradesum += i.Gold
		end

	end

end



Payment.select("date(created_at) as Day,sum(gold) Gold").group("date(created_at)").order("date(created_at)")


