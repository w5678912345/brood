class AccountSession < ActiveRecord::Base
  attr_accessible :finished, :finished_at, :finished_status, :remark, :started_at, :started_status,:ip
  attr_accessible :computer_name,:account_id,:role_session_id

  belongs_to :computer,:class_name => 'Computer',:foreign_key=>'computer_name',:primary_key=>'hostname'
  belongs_to :account,:primary_key=>'no',:conditions => {finished: false}

  has_one :role_session
  has_many :history_sessions

  def start_role(role)
    if self.role_session.nil? == false and self.role_session.role != role
      self.role_session.stop
    end

    create_role_session_from_role(role)
  end
  def create_role_session_from_role(role)
    self.create_role_session! :role_id => role.id,:start_level => role.level,:start_gold => role.total,:start_power => role.vit_power,:computer_id => role.qq_account.session.computer.id,:live_at => Time.now,:ip => self.ip
  end

end
