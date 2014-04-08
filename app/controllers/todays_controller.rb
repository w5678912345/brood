# encoding: utf-8
class TodaysController < ApplicationController
	def index
		@online_role_count = RoleSession.count
		@today_trade_gold = Payment.trade_scope.where("date(created_at)=?",Date.today).sum(:gold)
		@error_event_count = Note.where("date(created_at)=?",Date.today).event_scope("discardforyears").count
	end
end
