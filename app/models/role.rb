# encoding: utf-8
class Role < ActiveRecord::Base
	include RoleApi

  belongs_to :computer,:class_name => 'Computer'
  belongs_to :online_note, :class_name => 'note', :foreign_key => 'online_note_id'
  has_many   :notes,		:dependent => :destroy, :order => 'id DESC'
  has_many	 :payments, :order => 'id DESC'
  has_many   :comroles, :class_name => 'Comrole'
  has_many   :computers,:class_name => 'Computer',through: :comroles

  belongs_to  :qq_account, :class_name => 'Account',:foreign_key=>'account',:primary_key=>'no', :counter_cache => :roles_count

  #
  attr_accessible :role_index, :server,:level,:status,:vit_power,:account,:password,:online,:computer_id,:ip,:normal
  attr_accessible :close,:close_hours,:closed_at,:reopen_at,:locked,:lost,:is_seller,:ip_range,:online_at,:online_note_id
  # validates 
	validates_presence_of :account, :password
	# 可以上线的角色
  scope :can_online_scope, where(:online => false).where(:close => false).where(:locked=>false)
    .where(:lost=>false).where("vit_power > 0").where(:normal => true).where(:status=>1).where("level < ?",Setting.role_max_level)
	
	default_scope order("online desc").order("close asc").order("level desc").order("vit_power desc")

  scope :well_scope,where("(close_hours != 2400000 and close_hours != 120) or close_hours is null")

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
		return self.vit_power > 0 && !self.online && !self.close  && !self.locked && !self.lost && self.normal && self.status == 1
	end

	#def total_pay
		#self.payments.sum(:gold)
	#end

	def self.get_roles
		return self.can_online_scope
	end


  def self.get_role
    return self.get_roles.first
  end

  def get_seller
  	return Role.where(:is_seller => true).where(:server => self.server).first
  end


  def set_ip_range
  	self.notes.where(:api_name => "online")
  	#self.update_attributes(:ip_range => "" )
  end

  def find_or_create_server
  	return @_server if @_server
  	@_server = Server.find_by_name(self.server)
  	@_server = Server.create(:name=>self.server) unless @_server
  	return @_server
  end

  def date_notes date
    self.notes.day_scope(date).select("api_name,count(id) as ecount").group("api_name")
  end

  def sellers
  	return  find_or_create_server.roles
  end

  def sell_goods
  	return find_or_create_server.goods
  end

  def goods_price
  	return find_or_create_server.price
  end



	
  def to_account
    account =  Account.new(:no => self.account,:password => self.password,:server => self.server)
    account.roles << self
    account.roles_count = account.roles_count + 1
    account.save
  end

  def self.generate_accounts roles
    roles.each do |role|
      role.to_account
    end
  end
  #
	
end
	
