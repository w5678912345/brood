class AccountSession < ActiveRecord::Base
  attr_accessible :finished, :finished_at, :finished_status, :remark, :started_at, :started_status,:ip
  attr_accessible :computer_name,:account_id,:role_session_id

  belongs_to :computer,:class_name => 'Computer',:foreign_key=>'computer_name',:primary_key=>'hostname'
  belongs_to :account,:primary_key=>'no'

  has_one :role_session
  has_many :history_sessions

  def start_role(role)
    if self.role_session.nil? == false and self.role_session.role != role
      self.role_session.stop('NewRole')
    end

    create_role_session_from_role(role)
  end
  def create_role_session_from_role(role)
    self.create_role_session! :role => role,:start_level => role.level,:start_gold => role.total,:start_power => role.vit_power,:computer_id => self.computer.id,:live_at => Time.now,:ip => self.ip
  end
  def stop(is_success,msg)
    #binding.pry
    self.transaction do
      self.role_session.stop(msg) if self.role_session
      self.account.roles.update_all(:online => false)

      ip = Ip.find_or_create(self.ip)
      ip.update_attributes(:cooling_time=>25.hours.from_now)

      self.update_attributes :finished_at => Time.now,:finished => true,:remark => msg
    end
  end
end
