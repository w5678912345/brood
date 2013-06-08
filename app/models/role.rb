# encoding: utf-8
class Role < ActiveRecord::Base

  belongs_to :computer

  attr_accessible :role_index, :server,:level,:status,:vit_power,:account,:password,:online,:computer_id,:ip

  default_scope :order => 'id DESC'

  CODES = Api::CODES

  #
  def api_online opts
    # get ip
    ip = Ip.find_by_value(opts[:ip])
    if ip
      #return CODES[:ip_used] if ip.hours_ago < 24 # 
    else
      ip = Ip.create(:value => opts[:ip]) 
    end
    # get computer
    self.transaction do
      computer = Computer.find_by_id(opts[:computer_id]) if opts[:computer_id]
      return CODES[:not_find_computer] unless computer # not find computer
      # update computer and ip
      computer.update_attributes(:roles_count=>computer.roles_count+1) 
      ip.update_attributes(:use_count=>ip.use_count+1)
      return 1 if self.update_attributes(:online=>true,:computer_id=>computer.id,:ip=>ip.value)
    end
  end

  #
  def api_offline opts
    self.transaction do
       return CODES[:role_not_online] unless self.online
       self.computer.update_attributes(:roles_count=>self.computer.roles_count-1) if self.computer
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
     return 1 if self.save
  end

  def self.all_offline
    Role.update_all(:online => false)
  end

  def self.auto_offline
    last_at = Time.now.ago(30.minutes)
    roles = self.where(:online=>true)
    roles.each do |role|
      role.api_offline nil if role.online
    end
  end


end
	