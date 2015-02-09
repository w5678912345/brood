class AccountStatus < ActiveRecord::Base
  attr_accessible :hours, :status

  validates_uniqueness_of :status



  def self.data
  	_data = {}
  	AccountStatus.select("status,hours").each do |as|
  		_data[as.status] = as.hours
  	end
  	return _data;
  end

  after_commit do |as|
  	p '------- replace AccountStatus'
  	Account::STATUS.replace(AccountStatus.data)
  end
  def self.next_check_time
    Time.now < Time.now.change(:hour => 6) ? Time.now.change(:hour => 6) : Time.now.change(:hour => 6) + 1.day
  end
  def resume_time_from_now
    if self.status == 'delaycreate'
      AccountStatus.next_check_time
    else
      self.hours.to_i.hours.from_now
    end
  end
end
