# encoding: utf-8
class SessionsController < ApplicationController

	def index
		@sessions = Note.session_scope.list_search(params)
		per_page  = params[:per_page].blank? ? 20 : params[:per_page].to_i
		@sessions = @sessions.paginate(:page => params[:page], :per_page => per_page)
	end

	# 机器会话列表
	def computer
		@sessions = Note.computer_session_scope.list_search(params)
		per_page  = params[:per_page].blank? ? 20 : params[:per_page].to_i
		@sessions = @sessions.paginate(:page => params[:page], :per_page => per_page)
	end

	#账号会话列表
	def account
		@sessions = Note.account_session_scope.list_search(params)
		per_page  = params[:per_page].blank? ? 20 : params[:per_page].to_i
		@sessions = @sessions.paginate(:page => params[:page], :per_page => per_page)
	end

	#角色会话列表
	def role
		 @sessions = Note.role_session_scope .list_search(params)
		 per_page  = params[:per_page].blank? ? 20 : params[:per_page].to_i
		 @sessions = @sessions.paginate(:page => params[:page], :per_page => per_page)
	end

	def analysis
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
			count(DISTINCT role_id) as roles_count,
			sum(if(role_id = 0,sessions.hours,0)) as account_hours,
			sum(if(role_id > 0,sessions.hours,0)) as role_hours")
		.date_scope(@start_date,@end_date).group("date(created_at)").reorder("date(created_at) desc")
	end


	def show

	end



end