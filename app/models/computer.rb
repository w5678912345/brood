# encoding: utf-8
class Computer < ActiveRecord::Base
  CODES = Api::CODES
  STATUS = []
  EVENT = ['not_find_account']
  Btns = { "pass"=>"审核通过", "refuse"=>"拒绝通过","clear_bind_accounts" => "清空账号", "bind_accounts" => "分配账号","task"=>"远程任务"}

  attr_accessible :hostname, :auth_key,:status,:user_id,:roles_count,:started
  attr_accessible :check_user_id,:checked,:checked_at,:server,:updated_at,:version,:online_roles_count,:online_accounts_count
  attr_accessible :accounts_count,:session_id
  #has_many :comroles,:dependent => :destroy
  #has_many :computer_accounts,:dependent => :destroy

  belongs_to :user
  belongs_to :session, :class_name => 'Note',:foreign_key => 'session_id'
  belongs_to :check_user,:class_name => 'User'
  #has_many :online_roles,:class_name => 'Role',:con

  #has_many :roles,:class_name => 'Role', through: :comroles
  #has_many :accounts, :class_name => 'Account', through: :computer_accounts

  # 绑定账户
  has_many :accounts, :class_name => 'Account', :foreign_key => 'bind_computer_id'
  # 在线账户
  has_many :online_accounts, :class_name => 'Account', :foreign_key => 'online_computer_id'
  #
  has_many :notes, :order => 'id DESC'
  #
  default_scope order("updated_at DESC") #:order => 'server DESC'
  scope :checked_scope,where(:checked => true)
  scope :ubchecked_scope,where(:checked => false)
  scope :no_server_scope,where("server is null or server = '' ") #服务器为空的账号 
	#
  scope :started_scope, where("session_id > 0 ") #已开始的机器
  scope :stopped_scope, where("session_id = 0 ") #已停止的机器
  #
  validates_presence_of :hostname,:auth_key
  validates_uniqueness_of :auth_key

  #
  def is_started?
      return self.session_id > 0
  end

  #
  def self.find_by_key_or_id c
    computer = Computer.find_by_auth_key(c)
    computer = Computer.find_by_id(c) unless computer
    return computer
  end

	def check opts
		self.checked = opts[:checked]
	end

	def uncheck
		self.checked = false
	end

  def server_blank?
    return self.server.blank?
  end

  #
  def update_hours
    return unless self.session
    now = Time.now
    hours = (now - self.session.created_at)/3600
    self.session.update_attributes(:hours=>hours)
  end

  # 机器注册
  def api_reg opts
    return CODES[:not_valid_computer] unless self.valid?
    if self.save 
      return 1 if Note.create(:computer_id=>self.id,:ip=>opts[:ip],:api_name=>"computer_reg",:hostname=>self.hostname,:server=>self.server,:version=>self.version) 
    end
    return -1
  end

  # 机器开始
  def api_start opts
    return 0 if self.is_started?
    return CODES[:computer_unchecked] unless self.checked
    self.version = opts[:version] unless opts[:version].blank?
    # 创建session
    session = Note.create(:computer_id=>self.id,:ip=>opts[:ip],:api_name=>"computer_start",:msg=>opts[:msg],:version=>self.version,:hostname => self.hostname,:server=>self.server)
    return 1 if self.update_attributes(:session_id => session.id)
  end

  # 机器同步
  def api_sync opts
    self.version = opts[:version] unless opts[:version].blank?
    self.server = opts[:server] unless opts[:server].blank?
    return 1 if self.update_attributes(:updated_at => Time.now)
  end

  # 机器停止
  def api_stop opts
    return 0 unless self.is_started?
    now = Time.now
    hours = (now - session.created_at)/3600
    self.session.update_attributes(:ending=>true, :stopped_at=>now, :hours=>hours)
    Note.create(:computer_id=>self.id,:ip=>opts[:ip],:api_name=>"computer_stop",:msg=>opts[:msg],:version=>self.version,:hostname => self.hostname,:server=>self.server)
    return 1 if self.update_attributes(:session_id => 0)
  end

  # 自动绑定账户
  def auto_bind_accounts opts
    # 机器可以绑定的账户数
    accounts_count = Setting.computer_accounts_count  
    # 机器还可以绑定的账户数量
    can_accounts_count = accounts_count - self.accounts_count
    return if can_accounts_count < 1
    # 查询可以绑定的账户
    accounts = Account.waiting_bind_scope.where("server is null or server = '' or server = ? ",self.server).limit(can_accounts_count)
    accounts = accounts.where("status = ?",opts[:status]) unless opts[:status].blank?
    return if accounts.blank?
    accounts.each do |account|
      account.do_bind_computer(self,opts) # 绑定
    end
  end




  # 清空绑定账户
  def clear_bind_accounts opts
    accounts = self.accounts.stopped_scope
    accounts.each do |account|
        account.do_unbind_computer(opts)
    end
  end

  def find_or_create_server
    return @_server if @_server
    @_server = Server.find_by_name(self.server)
    @_server = Server.create(:name=>self.server) unless @_server
    return @_server
  end

  def self.reset_accounts_count
      computers = Computer.all
      computers.each do |computer|
        computer.update_attributes(:accounts_count => computer.accounts.count)
      end
  end

  def self.reset_online_accounts_count
      computers = Computer.all
      computers.each do |computer|
        computer.update_attributes(:online_accounts_count => computer.online_accounts.count)
      end
  end

  # 机器每天
  def self.auto_stop_start
    computers = Computer.started_scope
    h = {:ip=>"localhost",:msg=>"auto"}
    computers.each do |computer|
      computer.api_start(h)
      computer.api_stop(h)
    end
  end

  def self.auto_stop
    last_at = Time.now.ago(10.minutes).strftime("%Y-%m-%d %H:%M:%S")
    computers = Computer.where(:started=>true).where("updated_at < '#{last_at}'")
    computers.each do |computer|
      computer.api_stop({:ip=>"localhost",:msg=>"auto"})
    end
  end

  
end
