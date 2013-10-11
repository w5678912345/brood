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


  def api_set opts
       self.role_index = opts[:role_index] if opts[:role_index]
       self.server = opts[:server] if opts[:server]
       self.level = opts[:level] if opts[:level] && opts[:level].to_i > 0
       self.vit_power = opts[:vit_power] if opts[:vit_power]
       self.gold = opts[:gold] if opts[:gold]
       self.name = opts[:name]  unless opts[:name].blank?
       #...
       self.transaction do
        # Note.create(:role_id=>self.id,:computer_id=>self.computer_id,:ip=>opts[:ip],:api_name=>"sync",:msg=>opts.to_s)
      self.qq_account.online_role_id = self.id
      self.qq_account.save
      self.updated_at = Time.now
      self.total = self.total_pay + self.gold if self.gold_changed?
      Note.create(:role_id=>self.id,:computer_id=>self.computer_id,:ip=>opts[:ip],:api_name=>"success",:msg=>opts[:msg],:online_at=>self.online_at,:online_note_id=>self.online_note_id) if self.vit_power == 0  
        return 1 if self.save
       end
  end



	
  def to_account
    account =  Account.new(:no => self.account,:password => self.password,:server => self.server)
    account.roles << self
    account.roles_count = account.roles_count + 1
    account.ip_range = self.ip_range
    if self.bslocked
        account.status = 'bslocked'
    elsif self.close && self.close_hours == 2
      account.status = 'closed'
    elsif self.close && self.close_hours == 3
      account.status = 'exception'
    elsif self.close && (self.close_hours == 120 || self.close_hours == 2400000)
        account.status = 'discard'
    elsif self.locked
      account.status = 'locked'
    elsif self.lost
      account.status = 'lost'
    elsif self.online
      account.status = 'online'
      account.online_ip = self.ip
      account.online_role_id = self.id
      account.online_note_id = self.online_note_id
      account.online_computer_id = self.computer_id
    end

   
    account.save
  end

  def self.generate_accounts roles
    roles.each do |role|
      role.to_account
    end
  end
  #
	
end
	
