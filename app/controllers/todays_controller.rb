# encoding: utf-8
class TodaysController < ApplicationController
	def index
		@online_role_count = RoleSession.count
		@today_trade_gold = Payment.trade_scope.at_date(Date.today).sum(:gold)
		@error_event_count = Note.at_date(Date.today).event_scope("discardforyears").count
	end
	def server_online
		@server_online = initialize_grid(RoleSession.select("roles.server,count(*) as num").joins(:role).group("roles.server"))
	end
end
