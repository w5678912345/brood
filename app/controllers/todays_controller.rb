# encoding: utf-8
class TodaysController < ApplicationController
	def index
		@online_computer_count = Computer.started_scope.count
		@online_account_count = AccountSession.where(:finished => false).count
		@today_trade_gold = Payment.trade_scope.at_date(Date.today).sum(:gold)
		#.at_date(Date.today)
		@error_event_count = AccountSession.select("finished_status as status,count(id) as num").
			where(started_status: 'normal').group("status").at_date(Date.today).
			where(finished_status: ['discardforyears','discardfordays','bslocked','discardbysailia','exception','discardbysailia','locked'])
		@error_event_grid = initialize_grid(@error_event_count)
		#binding.pry
		nearest_check_time = Time.now.change(:hour => 6)
		next_check_time = Time.now > nearest_check_time ? nearest_check_time + 1.day : nearest_check_time
		
		@finished_role_count = Role.where(:today_success => true).count
		@online_role_count = RoleSession.count
		@can_use_role_count = Role.today_valid.joins(:qq_account).
			where("accounts.normal_at <= ? and accounts.enabled = 1 and accounts.bind_computer_id > 0",
						Time.now).count

		@all_valid_role_count = @finished_role_count + @can_use_role_count
	end
	def server_online
		@server_online = initialize_grid(RoleSession.select("roles.server,count(*) as num").joins(:role).group("roles.server").order("roles.server"))
		@server_online = initialize_grid(Role.started_scope.select("server,count(id) as num").group("server").order("server")) if params[:by] == 'role'
	end
	def computers
		per_page = params[:per_page] || 50

		warning_computers = Computer.joins("INNER JOIN account_sessions ON account_sessions.computer_id = computers.id AND account_sessions.finished = 0 left JOIN role_sessions ON role_sessions.account_session_id = account_sessions.id").where("role_sessions.id is null")

		@danger_count = Computer.where(:msg => 'not_find_account').where("session_id > 0").count
		@warning_count = warning_computers.count

		if params[:color] == 'danger'
			@computers = Computer.where(:msg => 'not_find_account').where("session_id > 0")
		elsif params[:color] == 'warning'
			@computers = warning_computers
		else
			@computers = Computer
		end
			@computers = initialize_grid(@computers,:include => {:account_sessions => :role_session} ,per_page: per_page,
      :order => 'hostname',
      :order_direction => 'asc',
      :include => [:account_sessions]
			)
	end
	def warning_computers
		@warning_computers = AccountSession.select("account_sessions.id,computers.hostname as hostname,(account_sessions.lived_at - account_sessions.created_at) as duration").
		  joins(:computer).joins("left JOIN role_sessions ON role_sessions.account_session_id = account_sessions.id").
		  where("role_sessions.id is null and account_sessions.finished = false").order("duration desc")
	end
end
			