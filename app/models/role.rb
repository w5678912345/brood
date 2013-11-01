# encoding: utf-8
class Role < ActiveRecord::Base
	include RoleApi

  STATUS = ['normal','disable']
  EVENT = ['answer_verify_code','restart_game','weak']

  belongs_to :computer,:class_name => 'Computer'
  belongs_to :online_note, :class_name => 'note', :foreign_key => 'online_note_id'
  belongs_to :session, :foreign_key => 'session_id'
  has_many   :notes,		:dependent => :destroy, :order => 'id DESC'
  has_many	 :payments, :order => 'id DESC'
  has_many   :comroles, :class_name => 'Comrole'
  has_many   :computers,:class_name => 'Computer',through: :comroles

  belongs_to  :qq_account, :class_name => 'Account',:foreign_key=>'account',:primary_key=>'no', :counter_cache => :roles_count

  #
  attr_accessible :role_index, :server,:level,:status,:vit_power,:account,:password,:online,:computer_id,:ip,:normal
  attr_accessible :close,:close_hours,:closed_at,:reopen_at,:locked,:lost,:is_seller,:ip_range,:online_at,:online_note_id
  attr_accessible :session_id,:updated_at
  # validates 
	validates_presence_of :account, :password
	# 可以上线的角色
  scope :can_online_scope, where(:online => false).where(:close => false).where(:locked=>false)
    .where(:lost=>false).where("vit_power > 0").where(:normal => true).where(:status=>1).where("level < ?",Setting.role_max_level)
	
	default_scope order("online desc").order("close asc").order("level desc").order("vit_power desc")

  scope :well_scope,where("(close_hours != 2400000 and close_hours != 120) or close_hours is null")

  #
  def is_started?
    return self.session_id > 0
  end

  #
  def total_gold
			self.gold + self.total_pay
	end

  #相同账号的角色
	def same_account_roles
			Role.where(:account=>self.account)
	end

	def display
		return "#{self.account}##{self.role_index}"
	end

    # 角色开始
  def api_start opts
    return CODES[:account_is_stopped] unless self.qq_account.is_started?  # 账户未开始，角色不能开始
    return CODES[:role_is_started] if self.is_started? # 角色开始了不能开始
    account_session = self.qq_account.session
    computer = account_session.computer
    self.transaction do
      # 创建会话
      session = Session.create(:computer_id => computer.id,:account=>self.account,:ip=>opts[:ip],:role_id=>self.id,
          :sup_id=> account_session.id,:hostname=>computer.hostname,:server => computer.server,:version => computer.version,:role_start_level=>self.level)
      # 修改帐号的上线角色ID
      self.qq_account.update_attributes(:online_role_id => self.id)
      # 记录note
      note = Note.create(:computer_id => computer.id, :account => self.account,:role_id=>self.id, :ip=>opts[:ip],:hostname=>computer.hostname,
       :api_name=>"role_start",:server=> self.server || computer.server,:msg=>opts[:msg],:session_id=>session.id,:level=>self.level)
      # 修改角色
      return 1 if self.update_attributes(:session_id => session.id)
    end
  end

  # 角色同步
  def api_sync opts
    return CODES[:role_is_stopped] unless self.is_started?
    session = self.session
    computer = session.computer
    # 修改角色属性
     self.role_index = opts[:role_index] unless opts[:role_index].blank?
     self.server = opts[:server] unless opts[:server].blank?
     self.level = opts[:level] if opts[:level] && opts[:level].to_i > 0
     self.vit_power = opts[:vit_power] unless opts[:vit_power].blank?
     self.gold = opts[:gold] unless opts[:gold].blank?
     self.name = opts[:name]  unless opts[:name].blank?
     self.status = opts[:status] if STATUS.include? opts[:status]
     # 更新总产出
     self.total = self.total_pay + self.gold if self.gold_changed?
     # 
     self.transaction do
     
      # 如果状态发生改变，记录note
      if self.status_changed?
         Note.create(:account =>self.account,:role_id=>self.id,:computer_id=>computer.id,:ip=>opts[:ip],:hostname=> computer.hostname, :api_name=>'0',:server=>self.server || computer.server,
          :msg=>opts[:msg],:session_id=>session.id,:version=>computer.version,:server=>self.server,:api_code => self.status) 
          session.update_attributes(:status => status)
      end
      # 如果有事件发生，记录note
      if EVENT.include? opts[:event]
          Note.create(:account =>self.account,:role_id=>self.id,:computer_id=>computer.id,:ip=>opts[:ip],:hostname=> computer.hostname, :api_name=>opts[:event],:server=>self.server || computer.server,
          :msg=>opts[:msg],:session_id=>session.id,:version=>computer.version,:server=>self.server || computer.server) 
          
      end

      # 如果彼劳值变成了0,说明角色调度成功
      if self.vit_power_changed? && self.vit_power == 0 
          Note.create(:account =>self.account,:role_id=>self.id,:computer_id=>computer.id,:ip=>opts[:ip],:hostname=> computer.hostname, :server=>self.server || computer.server,
            :api_name=>"role_success",:msg=>opts[:msg],:session_id=>session.id)
          session.update_attributes(:success => true)
      end
      # 修改账号最后访问时间
      self.qq_account.update_attributes(:updated_at => Time.now)
      return 1 if self.update_attributes(:updated_at=>Time.now)
     end
  end


  # 角色停止
  def api_stop opts
    return CODES[:role_is_stopped] unless self.is_started?
    session = self.session
    computer = session.computer
    self.transaction do 
       # 修改帐号的上线角色ID
      self.qq_account.update_attributes(:online_role_id => 0)
      # 修改会话
      now = Time.now
      hours = (now - session.created_at)/3600
      session.update_attributes(:ending=>true, :end_at=>now,:hours=>hours,:role_end_level=>self.level)
      # 记录note
      Note.create(:computer_id => computer.id,:account => self.account,:role_id=>self.id, :ip=>opts[:ip],:hostname=>computer.hostname,
       :api_name=>"role_stop",:server=>self.server || computer.server,:msg=>opts[:msg],:session_id=> session.id)
      # 清空会话
      return 1 if self.update_attributes(:session_id => 0)
    end
  end

  # 角色支付
  def api_pay opts
    return CODES[:role_is_stopped] unless self.is_started?
    session = self.session
    computer = session.computer
    self.transaction do
      payment = Payment.new(:role_id=>self.id,:gold => opts[:gold],:balance => opts[:balance],:remark => opts[:remark],:note_id => 0,:pay_type=>opts[:pay_type],:server=>self.server||computer.server) 
      return CODES[:not_valid_pay] unless payment.valid? # validate not pass
      self.gold = payment.balance      #当前金币 = 支出后的余额
      self.total_pay = self.total_pay + payment.gold # 累计支出
      self.total = payment.total = self.total_pay + payment.balance # 产出总和
      # 发生支付是，将bslocked的账号 恢复为normal
      account = self.qq_account
      if account.status == 'bslocked' && payment.gold > 0 
         account.update_attributes(:status => 'normal')
         Note.create(:account => account.no,:role_id=>self.id,:computer_id=>computer.id,:ip=>opts[:ip],:api_code=>"bs_unlock_success",
          :version=>computer.version, :server=>self.server || computer.server,:session_id=>session.id, :msg=>"交易后自动解除锁定")
      end
      # 修改会话

      payment.save
      return 1 if  self.update_attributes(:updated_at=>Time.now)
    end
  end

  #
  def self.list_search opts
    roles = Role.includes(:qq_account)
    roles = roles.where("id = ?",opts[:id]) unless opts[:id].blank?
    roles = roles.where("server =?",opts[:server]) unless opts[:server].blank?
    roles = roles.where("account =?",opts[:account]) unless opts[:account].blank?
    roles = roles.where("status = ?",opts[:status])  unless opts[:status].blank?
    roles = roles.where("date(created_at) =?",opts["date(created_at)"]) unless opts["date(created_at)"].blank?
    unless opts[:level].blank?
      tmp_level = opts[:level].split("-")
      roles = roles.where("level = ?",tmp_level[0].to_i) if tmp_level.length == 1
      roles = roles.where("level >= ? and level <= ?",tmp_level[0].to_i,tmp_level[1].to_i) if tmp_level.length == 2
    end
    unless opts[:vit].blank?
      tmp_vit = opts[:vit].split("-")
      roles = roles.where("vit_power = ?",tmp_vit[0].to_i) if tmp_vit.length == 1
      roles = roles.where("vit_power >= ? and vit_power <= ?",tmp_vit[0].to_i,tmp_vit[1].to_i) if tmp_vit.length == 2 
    end
    return roles
  end


  def self.auto_stop
    last_at = Time.now.ago(10.minutes).strftime("%Y-%m-%d %H:%M:%S")
    roles = Role.where("session_id > 0").where("updated_at < '#{last_at}'")
    roles.each do |role|
      role.api_stop(opts={:ip=>"localhost"})
    end
  end



	
  def to_account
    account =  Account.new(:no => self.account,:password => self.password,:server => self.server)
    account.roles << self
    account.roles_count = account.roles_count + 1
    account.ip_range = self.ip_range
    account.created_at = self.created_at
    if self.bslocked
        account.status = 'bslocked'
    elsif self.close && self.close_hours == 2
      account.status = 'disconnect'
    elsif self.close && self.close_hours == 3
      account.status = 'exception'
    elsif self.close && (self.close_hours == 120 || self.close_hours == 2400000)
        account.status = 'discard'
    elsif self.locked
      account.status = 'locked'
    elsif self.lost
      account.status = 'lost'
    elsif self.online
      #account.status = 'online'
      # account.online_ip = self.ip
      # account.online_role_id = self.id
      # account.online_note_id = self.online_note_id
      # account.online_computer_id = self.computer_id
    end
    account.save
  end

  def self.generate_accounts roles
    roles.each do |role|
      role.to_account
    end
  end
  #

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

	
end
	
