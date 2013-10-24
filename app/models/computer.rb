# encoding: utf-8
class Computer < ActiveRecord::Base

  Btns = { "pass"=>"审核通过", "refuse"=>"拒绝通过","clear_bind_accounts" => "清空账号", "bind_accounts" => "分配账号","task"=>"远程任务"}

  attr_accessible :hostname, :auth_key,:status,:user_id,:roles_count,:started
  attr_accessible :check_user_id,:checked,:checked_at,:server,:updated_at,:version,:online_roles_count,:online_accounts_count
  attr_accessible :accounts_count
  #has_many :comroles,:dependent => :destroy
  #has_many :computer_accounts,:dependent => :destroy

  belongs_to :user
  belongs_to :check_user,:class_name => 'user'
  #has_many :online_roles,:class_name => 'Role',:con

  #has_many :roles,:class_name => 'Role', through: :comroles
  #has_many :accounts, :class_name => 'Account', through: :computer_accounts

  # 绑定账户
  has_many :accounts, :class_name => 'Account', :foreign_key => 'bind_computer_id'
  # 在线账户
  has_many :online_accounts, :class_name => 'Account', :foreign_key => 'online_computer_id'
  #
  has_many :notes, :order => 'id DESC'


  default_scope order("server DESC") #:order => 'server DESC'

  scope :checked_scope,where(:checked => true)
  scope :ubchecked_scope,where(:checked => false)
  scope :no_server_scope,where("server is null or server = '' ") #服务器为空的账号 
	 
  
  validates_presence_of :hostname,:auth_key,:user_id
  validates_uniqueness_of :auth_key

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

	def set_server
		return ! self.server.blank?
	end

  def start opts
    self.update_attributes(:started => true)
    Note.create(:computer_id=>self.id,:ip=>opts[:ip],:api_name=>"computer_online",:msg=>opts[:msg],:version=>self.version,:hostname => self.hostname,:server=>self.server)
  end

  def stop opts
    self.update_attributes(:started => false)
    Note.create(:computer_id=>self.id,:ip=>opts[:ip],:api_name=>"computer_offline",:msg=>opts[:msg],:version=>self.version,:hostname => self.hostname,:server=>self.server)
  end

  # 自动绑定账户
  def auto_bind_accounts opts
    # 机器可以绑定的账户数
    accounts_count = Setting.computer_accounts_count  
    # 机器还可以绑定的账户数量
    can_accounts_count = accounts_count - self.accounts_count
    return if can_accounts_count < 1
    # 查询可以绑定的账户
    accounts = Account.unbind_scope.where("server is null or server = '' or server = ? ",self.server).limit(can_accounts_count)
    accounts = accounts.where("status = ?",opts[:status]) unless opts[:status].blank?
    return if accounts.blank?
    # 绑定账户
    accounts.update_all(:bind_computer_id => self.id,:bind_computer_at => Time.now,:server => self.server)
    self.accounts_count = self.accounts_count + accounts.length
    self.save
  end

  # 清空绑定账户
  def clear_bind_accounts
    self.accounts.update_all(:bind_computer_id => -1) #
    self.update_attributes(:accounts_count => 0) # 修改 绑定账户数量
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

  
end
