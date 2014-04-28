# encoding: utf-8
class TodaysController < ApplicationController
	def index
		@online_role_count = RoleSession.count
		@today_trade_gold = Payment.trade_scope.at_date(Date.today).sum(:gold)
		@error_event_count = Note.at_date(Date.today).event_scope("discardforyears").count
		@finished_role_count = HistoryRoleSession.at_date(Date.today).count(:role_id,:distinct => true)
		@can_use_role_count = Role.joins(:qq_account).where("accounts.status = 'normal'").count
	end
	def server_online
		@server_online = initialize_grid(RoleSession.select("roles.server,count(*) as num").joins(:role).group("roles.server").order("roles.server"))
		@server_online = initialize_grid(Role.started_scope.select("server,count(id) as num").group("server").order("server")) if params[:by] == 'role'
	end
end
			