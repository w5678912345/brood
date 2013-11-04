# encoding: utf-8
class Analysis::SessionController < Analysis::AppController
	
	def show
		@date = Date.parse params[:date] unless params[:date].blank?
		@date = Date.today unless @date

		
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