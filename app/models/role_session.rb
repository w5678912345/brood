class RoleSession < ActiveRecord::Base
  attr_accessible :computer_id, :connection_times, :exchanged_gold, :live_at, :role_id, :start_exp, :start_gold, :start_level, :task, :used_gold, :ip
  belongs_to :role
  belongs_to :computer  
  def self.create_from_role(role,ip)
  	binding.pry
  	RoleSession.create! :role_id => role.id,:start_level => role.level,:start_gold => role.total,:computer_id => role.qq_account.session.computer.id,:live_at => Time.now,:ip => ip
  end
  def live_now
  	self.update_attributes(:live_at => Time.now)
  end
  def stop(result)
  	self.destroy
  end
end
