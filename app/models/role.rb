# encoding: utf-8
class Role < ActiveRecord::Base
	include RoleApi

  belongs_to :computer
  has_many   :notes,		:dependent => :destroy, :order => 'id DESC'
  has_many	 :payments,	:dependent => :destroy, :order => 'id DESC'

	#has_many   :roles,		:class_name => 'Role',	:foreign_key => 'account'

  attr_accessible :role_index, :server,:level,:status,:vit_power,:account,:password,:online,:computer_id,:ip
  attr_accessible :close,:close_hours,:closed_at,:reopen_at,:locked,:lost,:is_seller,:ip_range

  #default_scope :order => 'id DESC'

	validates_presence_of :account, :password
	#
  scope :can_online_scope, where(:online => false).where(:close => false).where(:locked=>false).where(:lost=>false).where("vit_power > 0")
	
	default_scope order("online desc").order("close asc").order("level desc").order("vit_power desc")

  def total_gold
			self.gold + self.total_pay
	end

	def same_account_roles
			Role.where(:account=>self.account)
	end

	def display
		return "#{self.account}##{self.role_index}"
	end

	def can_online
		return self.vit_power > 0 && !self.online && !self.close  && !self.locked && !self.lost 
	end

	#def total_pay
		#self.payments.sum(:gold)
	#end

	def self.get_roles
		roles = self.can_online_scope
	    role_max_level = Setting.find_value_by_key("role_max_level")
	    if role_max_level
	      roles = roles.where("level <= #{role_max_level}")
	    end
	    return roles
	end


  def self.get_role
    return self.get_roles.first
  end

  def get_seller
  	return Role.where(:is_seller => true).where(:server => self.server).first
  end

  def set_seller
  	#self.update(:is_seller => true)
  end

  def set_ip_range
  	self.notes.where(:api_name => "online")
  	#self.update_attributes(:ip_range => "" )
  end
	
  #
	
end
	
