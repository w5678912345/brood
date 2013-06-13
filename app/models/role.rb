# encoding: utf-8
class Role < ActiveRecord::Base

  belongs_to :computer
  has_many   :notes

  attr_accessible :role_index, :server,:level,:status,:vit_power,:account,:password,:online,:computer_id,:ip

  #default_scope :order => 'id DESC'

  scope :can_online_scope, where(:online => false).where("vit_power > 0").order("vit_power desc")


  CODES = Api::CODES

  #
  def api_online opts
    return CODES[:role_have_online] if self.online
    # get computer
    computer = Computer.find_by_auth_key(opts[:ckey])
    return CODES[:not_find_computer] unless computer
    # get ip
    ip = Ip.find_by_value(opts[:ip])
    if ip
      return CODES[:ip_used] if ip.use_count >= Setting.ip_max_use_count
    else
      ip = Ip.create(:value => opts[:ip]) 
    end
    self.transaction do
      computer.update_attributes(:roles_count=>computer.roles_count+1) 
      ip.update_attributes(:use_count=>ip.use_count+1)
      Note.create(:role_id=>self.id,:computer_id=>computer.id,:ip=>ip.value,:api_name=>"online")
      return 1 if self.update_attributes(:online=>true,:computer_id=>computer.id,:ip=>ip.value)
    end
  end

  #
  def api_offline opts
    self.transaction do
       return CODES[:role_not_online] unless self.online
       self.computer.update_attributes(:roles_count=>self.computer.roles_count-1) if self.computer
       Note.create(:role_id=>self.id,:computer_id=>self.computer_id,:ip=>opts[:ip],:api_name=>"offline")
       return 1 if self.update_attributes(:online=>false,:computer_id=>0,:ip=>nil)
    end
  end

  #
  def api_sync opts
     self.role_index = opts[:role_index] if opts[:role_index]
     self.server = opts[:server] if opts[:server]
     self.level = opts[:level] if opts[:level]
     self.vit_power = opts[:vit_power] if opts[:vit_power]
     #...
     self.transaction do
      Note.create(:role_id=>self.id,:computer_id=>self.computer_id,:ip=>opts[:ip],:api_name=>"sync")
      return 1 if self.save
     end
  end

  def api_close opts
     self.transaction do
      self.close = true
      self.close_hours = opts[:h].to_i
      self.closed_at = Time.now
      self.reopen_at = Time.now.ago(self.close_hours.hours)
      Note.create(:role_id=>self.id,:ip=>opts[:ip],:api_name=>"close")
      return 1 if self.save
   end
  end


  #
  def self.auto_offline
    last_at = Time.now.ago(10.minutes).strftime("%Y-%m-%d %H:%M:%S")
    roles = self.where(:online=>true).where("updated_at < '#{last_at}'")
    opts = Hash.new
    roles.each do |role|
      role.api_offline opts if role.online
    end
  end

  def self.reset_vit_power
    Role.update_all(:vit_power=>156)
  end



end
	