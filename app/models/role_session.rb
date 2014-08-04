class RoleSession < ActiveRecord::Base
  attr_accessible :computer_id, :connection_times, :exchanged_gold, :live_at, :role_id, :start_exp, :start_gold, :start_level,:start_power, :task, :used_gold, :ip
  belongs_to :role
  belongs_to :computer  

  belongs_to :instance_map, :counter_cache => :enter_count
  def duration
  	live_at - created_at
  end
  def self.create_from_role(role,ip)
  	RoleSession.create! :role_id => role.id,:start_level => role.level,:start_gold => role.total,:start_power => role.vit_power,:computer_id => role.qq_account.session.computer.id,:live_at => Time.now,:ip => ip
  end
  def live_now
  	self.update_attributes(:live_at => Time.now)
  end
  def stop(result)
    HistoryRoleSession.create_from_role_session(self,result)
  	self.destroy
  end
end
