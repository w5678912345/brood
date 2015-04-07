class AccountSession < ActiveRecord::Base
  attr_accessible :finished, :finished_at, :finished_status, :remark, :started_at,:lived_at, :started_status,:ip
  attr_accessible :computer_id,:account_id,:role_session_id,:start_count

  belongs_to :computer
  belongs_to :account,:primary_key=>'no'

  has_one :role_session
  has_many :history_role_sessions

  scope :at_date,lambda{|day| where(created_at: day.beginning_of_day..day.end_of_day)}
  scope :finished_at_date,lambda{|day| where(lived_at: day.beginning_of_day..day.end_of_day)}

  def start_role(role)
    #starting role is not current role
    if self.role_session and self.role_session.role_id != role.id
      self.role_session.stop(false)
    end

    create_role_session_from_role(role)
  end
  def create_role_session_from_role(role)
    self.create_role_session! :role => role,:start_level => role.level,:start_gold => role.total,:start_power => role.vit_power,:computer_id => self.computer.id,:live_at => Time.now,:ip => self.ip
  end
  def stop(is_success,msg="")
    Accounts::StopService.new(self).run is_success,msg
    return 1
  end
  def stop_old(is_success,msg="")
    #binding.pry
    return 1 if self.transaction do
      self.finished_status = self.started_status if self.finished_status.nil?

      self.role_session.stop(is_success) if self.role_session
      self.account.roles.update_all(:online => false)

      normal_at = self.account.normal_at
      today_success = self.account.today_success
      if is_success
        normal_at = AccountStatus.next_check_time
        today_success = self.finished_status == 'normal'
      else
        #如果不是成功退出，那么冷却时间应该以note发生的时间开始计时，所以normal_at会在note发生的时候改变
        status = AccountStatus.find_by_status(self.finished_status)
        normal_at = status.resume_time_from_now if status
      end
      self.account.update_attributes :today_success => today_success,:session_id => 0#,:normal_at => normal_at 

      ip = Ip.find_or_create(self.ip)
      ip.update_attributes(:cooling_time=>25.hours.from_now)

      self.remark = msg if msg and msg.empty? == false
      self.update_attributes :finished_at => Time.now,:finished => true
    end
  end
end
