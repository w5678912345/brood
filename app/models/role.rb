# encoding: utf-8
class Role < ActiveRecord::Base
	include RoleApi

  STATUS = ['normal','disable','discardforverifycode','disableforlevel']
  EVENT = ['answer_verify_code','restart_game','weak','msg_event']
  Btns = {"set_status"=>"修改状态","set_today_success"=>"设置今日成功","set_profession"=>"修改职业"}

  PROFESSIONS = ['gunner','witch','darkknight'] #

  belongs_to :computer,:class_name => 'Computer'
  belongs_to :online_note, :class_name => 'note', :foreign_key => 'online_note_id'
  belongs_to :session, :class_name => 'Note', :foreign_key => 'session_id'
  belongs_to :role_profile, :counter_cache => true
  has_many   :notes,		:dependent => :destroy, :order => 'id DESC'
  has_many	 :payments, :order => 'id DESC'
  has_many   :comroles, :class_name => 'Comrole'
  has_many   :computers,:class_name => 'Computer',through: :comroles
  has_one    :role_session
  has_many   :history_role_sessions
  belongs_to  :qq_account, :class_name => 'Account',:foreign_key=>'account',:primary_key=>'no', :counter_cache => :roles_count

  #
  attr_accessible :role_index, :server,:level,:status,:vit_power,:account,:password,:online,:computer_id,:ip,:normal
  attr_accessible :close,:close_hours,:closed_at,:reopen_at,:locked,:lost,:is_seller,:ip_range,:online_at,:online_note_id
  attr_accessible :session_id,:updated_at,:today_success,:is_helper,:channel_index,:name,:ishell,:profession,:total
  # validates 
	validates_presence_of :account, :password
	# 可以上线的角色
  # scope :can_online_scope, where(:online => false).where(:close => false).where(:locked=>false)
  #   .where(:lost=>false).where("vit_power > 0").where(:normal => true).where(:status=>1).where("level < ?",Setting.role_max_level)
	
	#default_scope order("account desc").order("level desc").order("vit_power desc")

  scope :well_scope,where("(close_hours != 2400000 and close_hours != 120) or close_hours is null")

  scope :online_scope, where(:online=>true)
  scope :started_scope, where("session_id > 0 ") #已开始的角色
  scope :stopped_scope, where("roles.session_id = 0 ") #已停止的角色
  # 等待上线的角色
  scope :waiting_scope,stopped_scope.where("roles.status = 'normal' and roles.session_id = 0 and roles.online = 0 and roles.today_success = 0").reorder("is_helper desc").readonly(false)

  scope :can_used,where("roles.status = 'normal' and roles.online = 0 and roles.today_success = 0 and roles.vit_power > 5").
    where("roles.level < ?",Setting.role_max_level).reorder("roles.updated_at desc")
  def self.all_status
    STATUS
  end
  #
  def is_started?
    return self.role_session != nil
  end
  def can_start?
    self.status == 'normal' and self.today_success == false
  end
  def stop(result = "")
    self.role_session.stop(result) if self.role_session
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

  def make_note
  end
  # 角色开始
  def api_start opts
    #此处是判断角色是否在账号启动的时候发送给客户端
    #也就是此角色是否被调度的标志，但是这里比较奇怪
    #如果不被调度，此处start应该永远不会被调用，是
    #防御性代码？
    return 0 unless self.online

    if self.is_started?
      self.role_session.connection_times+=1
      self.role_session.save
      return CODES[:role_is_started] 
    end
    return CODES[:account_is_stopped] unless self.qq_account.is_started?  # 账户未开始，角色不能开始
    account_session = self.qq_account.session
    computer = account_session.computer

    self.transaction do
       #创建session
       session = Note.create(:computer_id => computer.id, :account => self.account,:role_id=>self.id, :ip=>opts[:ip],:hostname=>computer.hostname,
       :api_name=>"role_start",:server=> self.server || computer.server,:msg=>opts[:msg],:level=>self.level,:session_id =>account_session.id,:version=>computer.version,:target=>opts[:target])
      # 修改账号的当前角色
      self.qq_account.update_attributes(:online_role_id => self.id)
      r = RoleSession.create_from_role(self,opts[:ip])      
      # 修改角色 session
       return 1 if self.update_attributes(:session_id => session.id)
    end
  end

  # 角色同步
  def api_sync opts
  return CODES[:account_is_stopped] unless self.qq_account.is_started? 
   #binding.pry
   unless self.is_started?
      self.api_start opts
   end
    status = opts[:status]
    event = opts[:event]
    # 修改角色属性
     self.role_index = opts[:role_index] unless opts[:role_index].blank?
     self.server = opts[:server] unless opts[:server].blank?
     self.level = opts[:level] if opts[:level] && opts[:level].to_i > 0
     self.vit_power = opts[:vit_power] unless opts[:vit_power].blank?
     self.gold = opts[:gold] unless opts[:gold].blank?
     self.name = opts[:name]  unless opts[:name].blank?
     self.channel_index = opts[:channel_index] unless opts[:channel_index].blank?
     self.ishell = opts[:ishell].to_i unless opts[:ishell].blank?
     # 更新总产出
     self.total = self.total_pay + self.gold if self.gold_changed?
     # 
     self.transaction do
      self.qq_account.update_attributes(:updated_at => Time.now)
 
      if(self.role_session)
        self.role_session.live_now
      end
      # 修改角色最后访问时间
      return 1 if self.update_attributes(:updated_at => Time.now)
     end
  end


  def api_note opts
     return CODES[:role_is_stopped] unless self.is_started?
     status = opts[:status]
     event = opts[:event]
     api_name = "0",api_code = "0"
     computer = self.role_session.computer
     return 0 unless  (STATUS.include? status) || (EVENT.include? event) #事件和状态都未定义，不进行更新
     self.transaction do
       if STATUS.include? status
         api_name = status # 如果定义了有效状态 设置 api_name => status
         api_code = status # 如果定义了有效状态 设置 api_code => status
         self.status = status 
       end
       api_name = event if EVENT.include? event # 如果定义了有效事件，设置api_name => event
       # 发生事件或状态改变时，插入记录
        Note.create(:account =>self.account,:role_id=>self.id,:computer_id=>computer.id,:ip=>opts[:ip],:hostname=> computer.hostname, 
              :api_name=> api_name,:api_code => api_code,:msg=>opts[:msg],:session_id=>self.qq_account.session_id,
              :version=>computer.version,:server=>self.server || computer.server) 
        #

        if self.role_session
          self.role_session.live_now
        end
        return 1 if self.update_attributes(:updated_at => Time.now)
      end
  end


  # 角色停止
  def api_stop opts
    return CODES[:role_is_stopped] unless self.is_started?

    self.role_session.stop opts[:success] == '1'
  end

  # 角色支付
  def api_pay opts
    #return CODES[:role_is_stopped] unless self.is_started?
    # unless self.is_started?
    #   self.api_start opts
    # end
    #account_session = self.qq_account.session
    # session = self.session
    # computer = session.computer
    computer = Computer.find_by_auth_key(opts[:ckey])
    
    self.transaction do
      if opts[:tick_time]
        note_id = opts[:tick_time].to_i
      else
        note_id = rand(999999999) 
      end
      
      return 1 if Payment.where(:role_id => self.id,:note_id => note_id).first
      payment = Payment.new(:role_id=>self.id,:gold => opts[:gold],:balance => opts[:balance],:remark => opts[:remark],:note_id => note_id,:pay_type=>opts[:pay_type],:server=>self.server||computer.server,:target=>opts[:target]) 
      return CODES[:not_valid_pay] unless payment.valid? # validate not pass
      self.gold = payment.balance      #当前金币 = 支出后的余额
      self.total_pay = self.total_pay + payment.gold # 累计支出
      self.total = payment.total = self.total_pay + payment.balance # 产出总和
      # 发生支付是，将bslocked的账号 恢复为normal
      account = self.qq_account
      # if account.status == 'bslocked' && payment.gold > 0 
      #    account.update_attributes(:status => 'normal')
      #    Note.create(:account => account.no,:role_id=>self.id,:computer_id=>computer.id,:ip=>opts[:ip],:api_name=>"bs_unlock_success",
      #     :version=>computer.version, :server=>self.server || computer.server,:session_id=>account_session.id, :msg=>"交易后自动解除锁定")
      # end
      # 修改会话
      if opts[:pay_type] == 'trade' and self.role_session
        self.role_session.exchanged_gold += opts[:gold].to_i if self.role_session
        self.role_session.save if self.role_session
      end
      payment.save
      return 1 if  self.update_attributes(:updated_at=>Time.now)
    end
  end

  #
  def self.list_search opts
    roles = Role.includes(:qq_account,:session)
    roles = roles.where("id = ?",opts[:id]) unless opts[:id].blank?
    #roles = roles.where("server =?",opts[:server]) unless opts[:server].blank?
    roles = roles.where("server like ?","%#{opts[:server]}%") unless opts[:server].blank?
    roles = roles.where("account =?",opts[:account]) unless opts[:account].blank?
    roles = roles.where("status = ?",opts[:status])  unless opts[:status].blank?
    roles = roles.where("online = ?",opts[:online].to_i) unless opts[:online].blank?
    roles = roles.where("today_success =?",opts[:ts].to_i) unless opts[:ts].blank?
    roles = roles.where("profession =?",opts[:profession]) unless opts[:profession].blank?
    roles = roles.where(:role_index => opts[:index].to_i) unless opts[:index].blank?
    #
    roles = roles.where("date(created_at) =?",opts["date(created_at)"]) unless opts["date(created_at)"].blank?
    unless opts[:started].blank?
      roles = opts[:started].to_i == 1 ? roles.started_scope : roles.stopped_scope
    end
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
    roles = Role.where("session_id > 0").where("updated_at < ?",10.minutes.ago)
    roles.each do |role|
      role.api_stop(opts={:ip=>"localhost"})
    end
  end



#  discardfordays
#  discardforyears
#  discardbysailia
  def to_account
    account =  Account.new(:no => self.account,:password => self.password,:server => self.server)
    account.roles << self
    account.roles_count = account.roles_count + 1
    account.ip_range = self.ip_range
    account.created_at = self.created_at
    account.updated_at = self.updated_at
    account.normal_at = self.reopen_at

    if self.bslocked
        account.status = 'bslocked'
    elsif self.close && self.close_hours == 2
      account.status = 'disconnect'
    elsif self.close && self.close_hours == 3
      account.status = 'exception'
    elsif self.close && (self.close_hours == 120 || self.close_hours == 72)
        account.status = 'discardfordays'
    elsif self.close && (self.close_hours == 120000)
        account.status = 'discardbysailia'
    elsif self.close && (self.close_hours == 2400000)
        account.status = 'discardforyears'
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
    if account.normal_at.blank?
        account.normal_at = account.updated_at.since(Account::STATUS[account.status].hours)
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
	
