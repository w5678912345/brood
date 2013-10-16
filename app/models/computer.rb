# encoding: utf-8
class Computer < ActiveRecord::Base
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
	 
  
  validates_presence_of :hostname,:auth_key,:user_id
  validates_uniqueness_of :auth_key


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
    Note.create(:computer_id=>self.id,:ip=>opts[:ip],:api_name=>"start_computer",:msg=>opts[:msg])
  end

  def stop opts
    self.update_attributes(:started => false)
    Note.create(:computer_id=>self.id,:ip=>opts[:ip],:api_name=>"stop_computer",:msg=>opts[:msg])
  end

  # 自动绑定账户
  def auto_bind_accounts
    # 机器可以绑定的账户数
    accounts_count = Setting.computer_accounts_count  
    # 机器还可以绑定的账户数量
    can_accounts_count = accounts_count - self.accounts_count
    return if can_accounts_count < 1
    # 查询可以绑定的账户
    accounts = Account.unbind_scope.where("server is null or server = '' or server = ? ",self.server).limit(can_accounts_count)
    return if accounts.blank?
    # 绑定账户
    accounts.update_all(:bind_computer_id => self.id,:bind_computer_at => Time.now,:server => self.server)
    self.accounts_count = self.accounts_count + accounts.length
    self.save
  end

  # 清空绑定账户
  def clear_bind_accounts
    self.accounts.update_all(:bind_computer_id => 0) #
    self.update_attributes(:accounts_count => 0) # 修改 绑定账户数量
  end

  def find_or_create_server
    return @_server if @_server
    @_server = Server.find_by_name(self.server)
    @_server = Server.create(:name=>self.server) unless @_server
    return @_server
  end
  
end
