class RoleSession < ActiveRecord::Base
  attr_accessible :computer_id, :connection_times, :exchanged_gold, :live_at, :role_id, :start_exp, :start_gold, :start_level,:start_power, :task,:in_hell, :used_gold, :ip,:instance_map_id
  attr_accessible :role
  belongs_to :role
  belongs_to :computer  
  belongs_to :account_session

  belongs_to :instance_map, :counter_cache => :enter_count
  
  def duration
  	live_at - created_at
  end
  def self.create_from_role(role,ip)
  	RoleSession.create! do |rs|
      rs.role_id = role.id
      rs.start_level = role.level
      rs.start_gold = role.total
      rs.start_power = role.vit_power
      rs.computer_id = role.qq_account.account_session.computer_id
      rs.live_at = Time.now
      rs.ip = ip
    end
  end
  def live_now
  	self.update_attributes(:live_at => Time.now)
  end
  def stop(is_success)
    if is_success and role
      role.update_attributes :today_success => true
    end
    HistoryRoleSession.create_from_role_session(self,self.account_session.finished_status)
  	self.destroy
    1
  end

  def instance_map_was
    return InstanceMap.find_by_id(self.instance_map_id_was)
  end

  # before_save do |role_session|
  #   if role_session.instance_map_id_changed?
  #     role_session.instance_map_was.decrement(:enter_count,1).save if role_session.instance_map_was && role_session.instance_map_was.enter_count>0
  #     role_session.instance_map.increment(:enter_count,1).save if role_session.instance_map 
  #   end
  # end

  # before_destroy do |role_session|
  #   role_session.instance_map.decrement(:enter_count,1).save if role_session.instance_map && role_session.instance_map.enter_count>0
  # end

end
