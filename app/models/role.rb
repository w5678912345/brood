# encoding: utf-8
class Role < ActiveRecord::Base
	include RoleApi

  belongs_to :computer
  has_many   :notes
	has_many	 :payments

  attr_accessible :role_index, :server,:level,:status,:vit_power,:account,:password,:online,:computer_id,:ip
  attr_accessible :close,:close_hours,:closed_at,:reopen_at,:gold

  #default_scope :order => 'id DESC'

	validates_presence_of :account, :password
	#
  scope :can_online_scope, where(:online => false).where(:close => false).where("vit_power > 0").where("server IS NOT NULL").order("vit_power desc").order("level desc")


  def total_gold
			self.gold + self.total_pay
	end

	def total_pay
		self.payments.sum(:gold)
	end

  def self.get_role
    roles = self.can_online_scope
    role_max_level = Setting.find_value_by_key("role_max_level")
    if role_max_level
      roles = roles.where("level <= #{role_max_level}")
    end
    return roles.first
  end

  #

end
	
