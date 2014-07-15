# encoding: utf-8
class Ip < ActiveRecord::Base
  attr_accessible :value,:updated_at,:use_count,:last_account,:cooling_time
  #set_primary_key :value

  self.primary_key = "value"
  #default_scope :order => 'updated_at DESC'



  def hours_ago
  	(Time.now.to_i - self.updated_at.to_i)/3600
  end

  def ip_url
  	self.value.gsub(".","_")
  end

  def can_use?
    return false , "IP Filter try false" unless IpFilter.try(self.value)
    if self.cooling_time
      return false , "IP cooling_time gt now" if self.cooling_time > Time.now
    end
    return false , "IP use_count gt ip_max_use_count" if self.use_count >= Setting.ip_max_use_count
    
    tmps = self.value.split(".")
    ip_range = "#{tmps[0]}.#{tmps[1]}.#{tmps[2]}"
    current_online_count = Account.started_scope.where("SUBSTRING_INDEX(online_ip,'.',3) = ?",ip_range).count(:id)
    return false , "IP range online_count gt setting" if current_online_count >= Setting.ip_range_max_online_count
    return true , "IP can use"
  end

  def self.find_or_create(value)
      ip = Ip.find_by_value(value)
      ip = Ip.create(:value => value) unless ip
      return ip
  end

  #
  def self.reset_use_count
  	Ip.where("use_count > 0").update_all(:use_count => 0)
  end

end
