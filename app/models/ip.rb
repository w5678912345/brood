# encoding: utf-8
class Ip < ActiveRecord::Base
  attr_accessible :value,:updated_at,:use_count
  #set_primary_key :value

  self.primary_key = "value"
  default_scope :order => 'updated_at DESC'



  def hours_ago
  	(Time.now.to_i - self.updated_at.to_i)/3600
  end

  def ip_url
  	self.value.gsub(".","_")
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
