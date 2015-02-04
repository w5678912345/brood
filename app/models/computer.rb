# encoding: utf-8
class Computer < ActiveRecord::Base
  CODES = Api::CODES
  STATUS = []
  EVENT = ['not_find_account','code_error','QQRegister']
  Btns = { "pass"=>"审核通过", "refuse"=>"拒绝通过","clear_bind_accounts" => "解绑账号", 
    "bind_accounts" => "分配账号","task"=>"远程任务","auto_binding_account"=>"自动绑定账号",
    "swap_account"=>"转移账号","set_group"=>"设置分组","set_status"=>"设置状态",
    "set_max_accounts"=>"设置最大账号数","set_allowed_new"=>"设置是否自动绑定新号",
    "set_client_count"=>"设置客户端数量","set_auto_unbind_account"=>"自动解绑账号"}

  attr_accessible :hostname, :auth_key,:status,:user_id,:roles_count,:started
  attr_accessible :check_user_id,:checked,:checked_at,:server,:updated_at,:version,:online_roles_count,:online_accounts_count
  attr_accessible :accounts_count,:session_id,:version,:auto_binding,:group,:allowed_new,:max_accounts,:real_name

  attr_accessible :finished_role_count,:msg
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
  has_many :notes, :order => 'id DESC',:foreign_key => 'computer_id'
  #
  has_many :account_sessions,:conditions => {:finished => false}
  has_many :history_account_sessions,:conditions => {:finished => true},:class_name => 'AccountSession',:foreign_key => 'computer_id'
  #default_scope order("updated_at DESC") #:order => 'server DESC'
  scope :checked_scope,where(:checked => true)
  scope :ubchecked_scope,where(:checked => false)
  scope :no_server_scope,where("server is null or server = '' ") #服务器为空的账号 
	#
  scope :started_scope, where("session_id > 0 ") #已开始的机器
  scope :stopped_scope, where("session_id = 0 ") #已停止的机器
  #
  validates_presence_of :hostname,:auth_key
  validates_uniqueness_of :auth_key

  def self.include_day_finished_role_count(day)
      joins(
       %{
         LEFT OUTER JOIN (
           SELECT b.computer_id, COUNT(distinct(b.role_id)) finished_role_count
           FROM   history_role_sessions b
           where result <> 'timeout' and created_at >= '#{day.beginning_of_day.to_s(:db)}' and  created_at < '#{day.end_of_day.to_s(:db)}'
           GROUP BY b.computer_id
         ) a ON a.computer_id = computers.id
       }
      ).select("computers.*, a.finished_role_count").where("a.finished_role_count > 0").reorder([:finished_role_count,:client_count])
  end
  def self.include_account_session_count
      joins(
       %{
         LEFT OUTER JOIN (
           SELECT b.computer_id, COUNT(b.id) account_count
           FROM   account_sessions b
           where b.finished = false
           GROUP BY b.computer_id
         ) a ON a.computer_id = computers.id
       }
      ).select("computers.*, a.account_count")
  end

  def is_started?
    return self.session_id>0
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

  def to_note_hash
    hash = {:computer_id => self.id,:version => self.version,:server => self.server,:hostname=>self.hostname}
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
    self.hostname = opts[:hostname] unless opts[:hostname].blank?
    self.real_name = opts[:real_name] unless opts[:real_name].blank?
    self.client_count = opts[:client_count].to_i unless opts[:client_count].blank?
    


    self.max_accounts = self.client_count * Setting.client_role_count
    
    # 创建session
    session = Note.create(:computer_id=>self.id,:ip=>opts[:ip],:api_name=>"computer_start",:msg=>opts[:msg],:version=>self.version,:hostname => self.hostname,:server=>self.server)
    return 1 if self.update_attributes(:session_id => session.id)
  end

  # 机器同步
  def api_sync opts
    self.version = opts[:version] unless opts[:version].blank?
    self.server = opts[:server] unless opts[:server].blank?
    self.real_name = opts[:real_name] unless opts[:real_name].blank?
    # 创建session
    if self.session.nil?
      self.session = Note.create(:computer_id=>self.id,:ip=>opts[:ip],:api_name=>"computer_start",:msg=>opts[:msg],:version=>self.version,:hostname => self.hostname,:server=>self.server)
    end
    return 1 if self.update_attributes(:updated_at => Time.now)
  end

  def api_note opts
    status = opts[:status]
    event = opts[:event]
    return 0 unless  (STATUS.include? status) || (EVENT.include? event) #事件和状态都未定义，不进行更新
    if EVENT.include?(event)
        Note.create(self.to_note_hash.merge(:msg=>opts[:msg],:api_name=>event,:ip=>opts[:ip]))
    end
    return 1 if self.update_attributes(:updated_at => Time.now)
  end

  # 机器停止
  def api_stop opts
    return 0 unless self.is_started?
    if self.session
      now = Time.now
      hours = (now - session.created_at)/3600
      self.session.update_attributes(:ending=>true, :stopped_at=>now, :hours=>hours)
    end
    Note.create(:computer_id=>self.id,:ip=>opts[:ip],:api_name=>"computer_stop",:msg=>opts[:msg],:version=>self.version,:hostname => self.hostname,:server=>self.server)
    return 1 if self.update_attributes(:session_id => 0)
  end

  # 自动绑定账户
  def auto_bind_accounts opts
    return if self.server.blank?
    avg = opts[:avg].to_i
    # 机器可以绑定的账户数
    accounts_count = self.max_accounts
    # 机器还可以绑定的账户数量
    if opts[:when_not_find].blank?
      can_accounts_count = accounts_count - self.accounts_count
      return if can_accounts_count < 1
      limit = avg > can_accounts_count ? can_accounts_count : avg
    else
      limit = 1
    end
    # 查询可以绑定的账户
    #binding.pry
    accounts = Account.waiting_bind_scope.joins(:roles).where("normal_at <= ?",Time.now).where("accounts.enabled = 1").where("roles.status = ?",'normal').where("roles.level < ?",Setting.role_max_level).reorder("roles.level desc").uniq().readonly(false)
    if self.allowed_new
      accounts = accounts.where("accounts.server is null or accounts.server = '' or accounts.server = ? ",self.server) 
    else
      accounts = accounts.where("accounts.server = ?",self.server)
    end
    accounts = accounts.where("status = ?",opts[:status]) unless opts[:status].blank?
    accounts = accounts.limit(limit)
    return if accounts.blank?
    accounts.each do |account|
      account.do_bind_computer(self,opts) # 绑定
    end
  end



  # 清空绑定账户
  def clear_bind_accounts opts
    accounts = self.accounts.stopped_scope
    accounts = accounts.where(:status=>opts[:status]) unless opts[:status].blank?
    accounts = accounts.limit(opts[:count].to_i) unless opts[:count].blank?
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

  def bind_account_when_not_find opts
    #current_role_count =  AccountRole.get_list({:tag=>"role",:bind_cid=>self.id,:rss=>"normal"}).count
    #if current_role_count < self.max_roles
      self.auto_bind_accounts({:ip=>opts[:ip],:msg=>"auto by start",:avg=>1,:when_not_find=>true}) 
    #end
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
      computer.api_stop(h)
      computer.api_start(h)
    end
  end

  def self.auto_stop
    last_at = Time.now.ago(30.minute)
    computers = Computer.started_scope.where("updated_at < ?",last_at)
    computers.each do |computer|
      computer.api_stop({:ip=>"localhost",:msg=>"auto"})
    end
  end

  def self.init_max_roles
    Computer.update_all("max_accounts = client_count * #{Setting.client_role_count}")
  end


  def self.set_2_accounts
    computers = Computer.where("accounts_count>2")
    computers.each do |computer|
      online_count =  computer.online_accounts_count

      if online_count >= 2
          computer.accounts.stopped_scope.where("normal_at < '2016-01-13 00:00:00'").update_all(:normal_at=>'2016-01-13 00:00:00')
      else
          i = 2-online_count  # 2,1
          computer.accounts.stopped_scope.where("normal_at < '2016-01-13 00:00:00'").update_all(:normal_at=>'2016-01-13 00:00:00')
          computer.accounts.stopped_scope.where("normal_at = '2016-01-13 00:00:00'").limit(i).update_all(:normal_at=>'2015-01-13 00:00:00')

      end
    end
  end


  # def gt_level
  #   computers.each do |computer|
      
  #   end
  # end

  
end
