# encoding: utf-8
class Account < ActiveRecord::Base
    CODES = Api::CODES
    # 账号可能发生的状态
    STATUS = ['normal','bslocked','bslocked_again','bs_unlock_fail','disconnect','exception','locked','lost','discard','no_rms_file','no_qq_token']
    # 账号可能发生的事件
    EVENT = ['bslock','bs_unlock_fail','bs_unlock_success']
    Btns = { "disable_bind"=>"禁用绑定","clear_bind"=>"启用绑定","add_role" => "添加角色","call_offline"=>"调用下线","set_status"=>"修改状态"}
    # 需要自动恢复normal的状态
    Auto_Normal = {"disconnect"=>2,"exception"=>3,"lost"=>24,"bslocked"=>72,"bs_unlock_fail"=>72}
    # 
    attr_accessible :no, :password,:server,:online_role_id,:online_computer_id,:online_note_id,:online_ip,:status
    attr_accessible :bind_computer_id, :bind_computer_at,:roles_count,:session_id,:updated_at
    attr_accessor :online_roles 
    #所属服务器
	  belongs_to :game_server, :class_name => 'Server', :foreign_key => 'server',:primary_key => 'name'
    belongs_to :session,     :class_name => 'Note', :foreign_key => 'session_id'
    #在线角色
    belongs_to :online_role, :class_name => 'Role', :foreign_key => 'online_role_id'
    #在线记录
   	belongs_to :online_note, :class_name => 'Note', :foreign_key => 'online_note_id'
    #在线机器
   	belongs_to :online_computer, :class_name => 'Computer', :foreign_key => 'online_computer_id' 
    #绑定机器
    belongs_to :bind_computer,  :class_name => 'Computer', :foreign_key => 'bind_computer_id'
    #包含角色
    has_many   :roles, :class_name => 'Role', :foreign_key => 'account', :primary_key => 'no'

    # 
    validates_uniqueness_of :no

    default_scope order("updated_at desc")
    scope :online_scope, where("session_id > 0") #
    scope :unline_scope, where("session_id = 0").reorder("updated_at desc") # where(:status => 'normal')
    #
    scope :started_scope, where("session_id > 0 ") #已开始的账号
    scope :stopped_scope, where("session_id = 0 ") #已停止的账号
    #
    scope :waiting_scope, joins(:roles).where("accounts.session_id = 0 and accounts.status = 'normal'")
    .where("roles.vit_power > 0 and roles.status = 'normal' and roles.session_id = 0 and roles.online = 0").where("roles.level < ?",Setting.role_max_level).readonly(false)
    #
    scope :bind_scope, where("bind_computer_id > 0") # 已绑定
    scope :waiting_bind_scope, where("bind_computer_id = 0") # 未绑定 ,等待绑定的账户
    scope :unbind_scope ,where("bind_computer_id = -1") # 不能绑定
    scope :un_normal_scope,where("status != 'normal' ") # 非正常状态的账号
    scope :no_server_scope,where("server is null or server = '' ") #服务器为空的账号 

    # session_id > 0 表示正在运行
    def is_started?
      return self.session_id > 0
    end

    # 帐号在线，并且在线角色ID > 0 表示正在工作
    def is_working?
      return self.is_started? && self.online_role_id > 0 
    end


    # 开始帐号
    def api_start opts
      # 判断账号是否在线
      return CODES[:account_is_started] if self.is_started?
      ip = Ip.find_or_create(opts[:ip])
      computer = Computer.find_by_auth_key(opts[:ckey])
      self.transaction do
        #增加计算机上线账号数
        computer.update_attributes(:online_accounts_count => computer.online_accounts_count+1)
        #增加ip使用次数
        ip.update_attributes(:use_count=>ip.use_count+1)
        #插入账号开始记录
        tmp = {:computer_id=>computer.id,:hostname=>computer.hostname,:ip=>ip.value,:api_name=>"account_start",
           :msg=>opts[:msg],:account => self.no,:server => self.server,:version => computer.version}
        # 记录 session
        session = Note.create(tmp)
        
        # 可以调度的角色
        @online_roles = opts[:all] ? self.roles : self.roles.waiting_scope
        @online_roles = @online_roles.reorder("level desc").limit(Setting.account_start_roles_count)
        # 调度角色
        tmp[:session_id] = session.id # 
        tmp[:api_name] = "role_online" #
        @online_roles.each do |role|
            tmp[:role_id] = role.id
            role_note = Note.create(tmp) # 创建角色会话
            role.update_attributes(:online=>true,:online_note_id=>role_note.id) # 修改角色 session_id
        end
        # 修改session 并修改上线 IP
        computer.save
        return 1 if self.update_attributes(:session_id=>session.id,:online_ip=>ip.value)
      end
    end


    # 同步帐号
    def api_sync opts
      return CODES[:account_is_stopped] unless self.is_started?
      status = opts[:status]
      event = opts[:event]
      return 0 unless  (STATUS.include? status) || (EVENT.include? event) #事件和状态都未定义，不进行更新
      session = self.session
      computer = session.computer
      api_name = "0",api_code = "0"
      #
      self.transaction do 
        # 记录账户改变的状态
        if STATUS.include? status
          api_name = status # 如果定义了有效状态 设置 api_name => status
          api_code = status # 如果定义了有效状态 设置 api_code => status
          self.status = status
          #session.update_attributes(:result => status)
          self.normal_at = Time.now.since(Account::Auto_Normal[status].hours) if Auto_Normal.has_key?(status)
        end
        #状态正常时，清空normal
        self.normal_at = nil if self.status == 'normal'
        # 记录账号发生的事件
        api_name = event if EVENT.include? event # 如果定义了有效事件，设置api_name => event
        
        Note.create(:computer_id=>computer.id,:hostname=>computer.hostname,:role_id => self.online_role_id,:ip=>opts[:ip],:api_name => api_name,
          :msg=>opts[:msg],:account => self.no,:server => self.server,:version => computer.version,:session_id=>session.id,:api_code=>api_code)
        return 1 if self.update_attributes(:updated_at => Time.now)
      end
    end


    # 停止帐号
    def api_stop opts
      # 判断账号是否在线
      return CODES[:account_is_stopped] unless self.is_started?
      # 停止已启动的角色
      self.roles.started_scope.each do |role|
        role.api_stop(opts)
      end
      # 当前 session
      session = self.session
      computer = session.computer
      self.transaction do 
      # 创建stop 记录
       Note.create(:account => self.no, :computer_id=>computer.id,:ip=>opts[:ip],:api_name=>'account_stop',:msg=>opts[:msg],
         :server => self.server || computer.server,:version => computer.version,:hostname=>computer.hostname,:session_id=>session.id)
       # 修改机器的上线账号数量
       computer.update_attributes(:online_accounts_count => computer.online_accounts_count-1) if computer.online_accounts_count > 0
       # 更新 session    
       now = Time.now
       hours = (now - session.created_at)/3600
      
       #p "=====================#{self.online_role_ids}====#{session.success_role_ids}"
       # 参数成功，或者online 的角色 等于 success 的角色 表示本次会话成功
       session.success = true if (opts[:success].to_i ==1) || (self.online_role_ids == session.success_role_ids)
       # 完成session 
       session.update_attributes(:ending=>true, :stopped_at =>now,:hours=>hours)
        # 修改角色 online
       self.roles.update_all(:online => false)
       # 修改账号的session_id 为0 并清空上线 IP
       return 1 if self.update_attributes(:session_id=>0,:online_ip=>nil)
      end
    end



    #搜索账号列表
    def self.list_search opts
    	accounts = Account.includes(:session,:bind_computer)
      accounts = accounts.where("no = ?", opts[:no]) unless opts[:no].blank?
    	accounts = accounts.where(:server => opts[:server]) unless opts[:server].blank?
      accounts = accounts.no_server_scope if opts[:no_server].to_i == 1
    	accounts = accounts.where("status = ?",opts[:status])	unless opts[:status].blank?
      accounts = accounts.where("roles_count = ?",opts[:roles_count].to_i) unless opts[:roles_count].blank?
      accounts = accounts.where("bind_computer_id = ?",opts[:bind_cid].to_i) unless opts[:bind_cid].blank?
      #
      unless opts[:started].blank?
        accounts = opts[:started].to_i == 1 ? accounts.started_scope : accounts.stopped_scope
      end
      unless opts[:bind].blank?
        accounts = accounts.bind_scope if opts[:bind] == 'bind'
        accounts = accounts.waiting_bind_scope if opts[:bind] == '0'
        accounts = accounts.unbind_scope if opts[:bind] == '-1'
      end
      unless opts[:ss].blank?
        accounts = accounts.where("status in (?)",opts[:ss])
      end
      # 根据在线IP 查询账户
      accounts = accounts.where("online_ip like ?","%#{opts[:online_ip]}%") unless opts[:online_ip].blank?
      accounts = accounts.where("online_computer_id = ?",opts[:online_cid].to_i) unless opts[:online_cid].blank?
      accounts = accounts.where("date(created_at) = ?",opts["date(created_at)"]) unless opts["date(created_at)"].blank?
      return accounts
    end


    def online_role_ids
      self.roles.online_scope.select(:id).reorder("id desc").uniq().map(&:id)
    end

    #为账号新建一个角色
    def add_new_role
      self.roles.build(:account=>self.no,:password => self.password,:role_index => self.roles.count,:vit_power=>156,:server => self.server)
      self.save
    end


    #可用的角色
    def available_roles
      self.roles.where("vit_power > 0 and status = 'normal' ")
    end

    # 重置账号绑定数量
    def self.reset_roles_count
      accounts = Account.all
      accounts.each do |account|
        account.update_attributes(:roles_count => account.roles.count)
      end
    end

    #账号自动恢复normal 状态
    def self.auto_normal
      now = Time.now.strftime("%Y-%m-%d %H:%M:%S")
      # 状态为可恢复，并且恢复时间小于当前时间的账号
      accounts = Account.where("status in (?)",Auto_Normal.keys).where("normal_at <= '#{now}'").reorder(:id)
      accounts.update_all(:status => "normal",:normal => nil,:updated_at => Time.now)
    end

   # 账号自动停止
   def self.auto_stop
      last_at = Time.now.ago(10.minutes).strftime("%Y-%m-%d %H:%M:%S")
      accounts = Account.started_scope.where("updated_at < '#{last_at}'")
      accounts.each do |account|
        account.api_stop(opts={:cid=>account.online_computer_id,:ip=>"localhost",:msg=>"auto"})
      end
   end

      # 自动禁用账号的绑定
   def self.auto_unbind
      time = Time.now.ago(1.day)
      accounts = Account.stopped_scope.where("bind_computer_id != -1").where("updated_at < ?",time)
      accounts.each do |account|
          account.do_unbind_computer(opts={:ip=>"localhost",:msg=>"auto"})
      end
   end


   # #绑定计算机
   # def bind_computer cid

   # end

   # 绑定机器
   def do_bind_computer computer,opts
      return unless computer
      return if self.bind_computer_id != 0
      self.transaction do 
        # 绑定机器
        self.update_attributes(:bind_computer_id => computer.id,:server => computer.server)
        # 修改机器绑定数量
        computer.update_attributes(:accounts_count =>computer.accounts_count+1)
        # 插入记录
        note = Note.create(:account => self.no, :computer_id=>computer.id || 0,:ip=>opts[:ip],:api_name=>'bind_computer',:msg=>opts[:msg],
           :server => self.server || computer.server,:version => computer.version,:hostname=>computer.hostname)
      end
   end

   # 取消绑定
   def do_unbind_computer opts
      return if self.bind_computer_id == -1
      computer = self.bind_computer
      self.transaction do 
        # 禁用绑定
        self.update_attributes(:bind_computer_id => -1)
        return unless computer
        # 修改机器的账号数量
        computer.update_attributes(:accounts_count=>computer.accounts_count-1) if computer.accounts_count > 0
        # 默认IP
        opts[:ip] = "localhost" if opts[:ip].blank?
        # 插入记录
        note = Note.create(:account => self.no, :computer_id=>computer.id || 0,:ip=>opts[:ip],:api_name=>'unbind_computer',:msg=>opts[:msg],
             :server => self.server || computer.server,:version => computer.version,:hostname=>computer.hostname)
      end
   end



    #
    def sellers
      return [] unless self.game_server
      return  self.game_server.roles
    end

    def sell_goods
      return "" unless self.game_server
      return  self.game_server.goods
    end

    def goods_price
      return 1 unless self.game_server
      return  self.game_server.price
    end

end
