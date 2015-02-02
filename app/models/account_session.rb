class AccountSession < ActiveRecord::Base
  attr_accessible :finished, :finished_at, :finished_status, :remark, :started_at,:lived_at, :started_status,:ip
  attr_accessible :computer_id,:account_id,:role_session_id

  belongs_to :computer
  belongs_to :account,:primary_key=>'no'

  has_one :role_session
  has_many :history_role_sessions

  scope :at_date,lambda{|day| where(created_at: day.beginning_of_day..day.end_of_day)}

  def start_role(role)
    if self.role_session.nil? == false and self.role_session.role_id != role.id
      self.role_session.stop(false,'NewRole')
    end

    create_role_session_from_role(role)
  end
  def create_role_session_from_role(role)
    self.create_role_session! :role => role,:start_level => role.level,:start_gold => role.total,:start_power => role.vit_power,:computer_id => self.computer.id,:live_at => Time.now,:ip => self.ip
  end
  def stop(is_success,msg="")
    #binding.pry
    return 1 if self.transaction do
      self.role_session.stop(is_success,msg) if self.role_session
      self.account.roles.update_all(:online => false)

      self.finished_status = self.started_status if self.finished_status.nil?
      nearest_check_time = Time.now.change(:hour => 6)
      normal_at = self.account.normal_at
      today_success = self.account.today_success
      if is_success
        normal_at = self.created_at < nearest_check_time ? nearest_check_time : 1.day.from_now.change(:hour => 6)
        today_success = self.finished_status == 'normal'
      else
        normal_at = Account::STATUS[self.status].hours.to_i.from_now if Account::STATUS.has_key?(self.finished_status)
      end
      self.account.update_attributes :normal_at => normal_at ,:today_success => today_success

      ip = Ip.find_or_create(self.ip)
      ip.update_attributes(:cooling_time=>25.hours.from_now)

      self.remark = msg if msg and msg.empty? == false
      self.update_attributes :finished_at => Time.now,:finished => true
    end
  end
end
