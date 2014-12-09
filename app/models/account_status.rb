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
  	p '-------replace Account::STATUS'
  	Account::STATUS.replace(AccountStatus.data)
  end

end
