class IpRange < ActiveRecord::Base
  attr_accessible :enabled, :ip, :ip_accounts_in_24_hours, :minutes, :online_count, :remark, :start_count

  #attr_accessible :ip, :remark, :start_count, :hours,:minutes ,:online_count,:ip_accounts_in_24_hours,:enabled

  validates_uniqueness_of :ip
  validates_presence_of :ip


  def self.find_by_ip_enabled(ip)
    return self.where(:enabled=>true,:ip=>ip).first
  end


end
