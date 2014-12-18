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

    #所有C段最大 在线数
    ip_range_max_online_count = Setting.ip_range_max_online_count
    #所有C段控制时间(分钟)
    in_minutes = Setting.in_range_minutes
    #所有C段 控制时间内 account_start 的IP个数
    setting_ip_range_start_count =  Setting.ip_range_start_count

    # C段
    ipr = IpRange.find_by_ip_enabled(ip_range)

    if ipr
      in_minutes = ipr.minutes #C段控制时间(分钟)
      setting_ip_range_start_count =  ipr.start_count #C段 控制时间内 account_start IP 个数
      ip_range_max_online_count = ipr.online_count #C段 最大在线数
    end

    #IP C 段当前现在数
    current_online_count = Account.started_scope.where("SUBSTRING_INDEX(online_ip,'.',3) = ?",ip_range).count(:id)
    return false , "IP range online_count >=  #{ip_range_max_online_count}" if current_online_count >= ip_range_max_online_count

    #IP C 段在控制时间内 的 account start 的 IP 个数
    start_count = Note.where(:api_name=>'account_start').where("SUBSTRING_INDEX(ip,'.',3) = ?",ip_range).where("created_at > ?",Time.now.ago(in_minutes.minutes)).count("DISTINCT ip")
    #
    return false,"#{ip_range} start_count gt #{setting_ip_range_start_count} within #{in_minutes} minutes" if start_count >= setting_ip_range_start_count
    
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
