# encoding: utf-8
class Analysis::SessionController < Analysis::AppController
	
	def show
		@start_date = Time.now - 7.day 
		@end_date = Time.now + 1.day
		@start_date = params[:start_date] unless params[:start_date].blank?
		@end_date = params[:end_date]  unless params[:end_date].blank?
		#
		#@account_sessions = Session.date_scope(@start_date,@end_date).accounts_scope
#if(ccc_news_comments.id = 'approved', ccc_news_comments.id, 0)
		#Session.select("date(created_at) as date,count(id),count(id) as scount").accounts_scope


		@tmp_sessions = Session.select("date(created_at) as date,
			sum(if(role_id = 0,1,0)) account_count,sum(if(success=1 and role_id = 0,1,0)) as account_success_count,
			sum(if(role_id>0,1,0)) as role_count,sum(if(success=1 and role_id>0,1,0)) as role_success_count,
			count(DISTINCT account) as acounts_count,
			count(DISTINCT role_id) as roles_count")
		.date_scope(@start_date,@end_date).group("date(created_at)").reorder("date(created_at) desc")

	end


	def tmp

		@sevenS = Note.select("date(created_at) as Day,sum(if(api_name = 'role_success',1,0)) as SuccCount,
				sum(if(api_name = 'role_start',1,0)) as OnlineCount,
				sum(if(api_name = 'close',1,0)) as CloseCount,
				sum(if(api_name = 'answer_verify_code',1,0)) as VerifyCodeCount
			").group("date(created_at)").
			time_scope(@start_time,@end_time).order("date(created_at)")

		@account_sessions = Session.day_scope(@date).accounts_scope
		@account_sessions_count = @account_sessions.count("id")
		@accounts_count = @account_sessions.count("DISTINCT(account)")
		@account_sessions = Session.day_scope(@date).accounts_scope.select("count(id) as scount,status").group("status")
		#
		@role_sessions = Session.day_scope(@date).roles_scope
		@role_sessions_count = @role_sessions.count("id")
		@roles_count = @role_sessions.count("role_id")
		@role_sessions = Session.day_scope(@date).roles_scope.select("count(id) as rscount,success").group("success") 
	end

end