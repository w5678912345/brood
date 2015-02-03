# encoding: utf-8
class TodaysController < ApplicationController
	def index
		@online_computer_count = Computer.started_scope.count
		@online_role_count = AccountSession.where(:finished => false).count
		@today_trade_gold = Payment.trade_scope.at_date(Date.today).sum(:gold)
		#.at_date(Date.today)
		@error_event_count = AccountSession.select("finished_status as status,count(id) as num").
			where(started_status: 'normal').group("status").at_date(Date.today).
			where(finished_status: ['discardforyears','discardfordays','bslocked','discardbysailia','exception','discardbysailia','locked'])
		@error_event_grid = initialize_grid(@error_event_count)
		#binding.pry
		nearest_check_time = Time.now.change(:hour => 6)
		next_check_time = Time.now > nearest_check_time ? nearest_check_time + 1.day : nearest_check_time
		
		@finished_role_count = Account.where(:last_start_at =>[next_check_time - 1.day,next_check_time]).where("today_success = 1 or normal_at >= ?",next_check_time).count
		@can_use_role_count = Account.where("normal_at < ?",next_check_time).count
	end
	def server_online
		@server_online = initialize_grid(RoleSession.select("roles.server,count(*) as num").joins(:role).group("roles.server").order("roles.server"))
		@server_online = initialize_grid(Role.started_scope.select("server,count(id) as num").group("server").order("server")) if params[:by] == 'role'
	end
end
			