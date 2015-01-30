class HistoryRoleSession < ActiveRecord::Base
  attr_accessible :account_id, :account_key, :begin_at, :begin_level, :begin_power, :computer_id, :connection_times, :end_at, :end_level, :end_power, :exchanged_gold, :game_version, :gold, :id, :ip, :result, :role_id, :role_name, :server, :task, :version

  belongs_to :computer
  belongs_to :account
  belongs_to :role
  belongs_to :account_session
  
  scope :at_date,lambda{|day| where(created_at: day.beginning_of_day..day.end_of_day)}


	def self.create_from_role_session(s,result)
		h = HistoryRoleSession.new
		#h.id = s.id
		h.role_id = s.role_id
		h.account_id = s.role.qq_account.id
		h.computer_id = s.computer_id
		h.account_session_id = s.account_session_id
		
		h.begin_at = s.created_at
		h.end_at = Time.now
		h.begin_level = s.start_level
		h.end_level = s.role.level
		h.begin_power = s.start_power
		h.end_power = s.role.vit_power
		h.connection_times = s.connection_times
		h.version = s.computer.version
		h.gold = s.role.total - s.start_gold
		h.exchanged_gold = s.exchanged_gold
		h.ip = s.ip
		h.task = s.task
		h.result = result
		#h.game_version = 
		h.account_key = s.role.account
		h.role_name = s.role.name
		h.server = s.role.server
		h.save
	end  
end
