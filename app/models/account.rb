# encoding: utf-8
class Account < ActiveRecord::Base
    CODES = Api::CODES
    # 账号可能发生的状态
    #STATUS = ['normal','bslocked','bslocked_again','bs_unlock_fail','disconnect','exception','locked','lost','discard','no_rms_file','no_qq_token','discardfordays','discardbysailia','discardforyears']
    #CAN_START_STATUS=['normal','bslocked','disconnect','exception']
    # 账号可能发生的事件
    EVENT = ['bslock','bs_unlock_fail','bs_unlock_success','code_error','wrong_password','study_sailiya','net_error','msg_event']
    Btns = { "disable_bind"=>"禁用绑定","clear_bind"=>"启用绑定","add_role" => "添加角色","call_offline"=>"调用下线","set_status"=>"修改状态","edit_normal_at"=>"修改冷却时间",
      "bind_this_computer"=>"绑定指定机器","set_server"=>"修改服务器","export" =>"导出账号","add_sms_order"=>"添加工单"}

    # 需要自动恢复normal的状态
    Auto_Normal = {"disconnect"=>2,"exception"=>3,"lost"=>0,"bslocked"=>72,"bs_unlock_fail"=>72}
    #
    STATUS = AccountStatus.data  #{"normal" => 0,"bslocked"=>72,"bslocked_again"=>72,"bs_unlock_fail"=>72,"disconnect"=>2,"exception"=>3,
      #{}"locked"=>1200, "lost"=>24,"discard"=>1200,"no_rms_file"=>72,"no_qq_token"=>1200,
      #{}"discardfordays"=>72,"discardbysailia"=>240,"discardforyears"=>12000,"discardforverifycode"=>1200,"recycle"=>12000}

    # 
    attr_accessible :no, :password,:server,:online_role_id,:online_computer_id,:online_note_id,:online_ip,:status
    attr_accessible :bind_computer_id, :bind_computer_at,:roles_count,:session_id,:updated_at,:today_success,:last_start_ip
    attr_accessible :remark,:is_auto,:phone_id,:normal_at,:unlock_phone_id,:unlocked_at,:rms_file,:phone_id, :in_cpo,:last_start_at

    attr_accessor :online_roles 
    #所属服务器
	  belongs_to :game_server, :class_name => 'Server', :foreign_key => 'server',:primary_key => 'name'
    belongs_to :session,     :class_name => 'Note', :foreign_key => 'session_id'
    #在线角色
    belongs_to :online_role, :class_name => 'Role', :foreign_key => 'online_role_id'
    #
    belongs_to :current_role, :class_name => 'Role', :foreign_key => 'current_role_id'
    #在线记录
   	belongs_to :online_note, :class_name => 'Note', :foreign_key => 'online_note_id'
    #在线机器,由于手动可以调度不属于自己的账号，导致绑定的机器和在线的机器可能不一样
   	belongs_to :online_computer, :class_name => 'Computer', :foreign_key => 'online_computer_id' 
    #绑定机器
    belongs_to :bind_computer,  :class_name => 'Computer', :foreign_key => 'bind_computer_id'
    #绑定的电话
    belongs_to :phone
    #包含角色
    has_many   :roles, :class_name => 'Role', :foreign_key => 'account', :primary_key => 'no'

    # 
    validates_uniqueness_of :no

    #default_scope order("accounts.session_id desc").order("normal_at asc").order("updated_at desc")
    scope :online_scope, where("accounts.session_id > 0") #
    scope :unline_scope, where("accounts.session_id = 0").reorder("updated_at desc") # where(:status => 'normal')
    #
    scope :started_scope, where("accounts.session_id > 0 ") #已开始的账号
    scope :stopped_scope, where("accounts.session_id = 0 ") #已停止的账号
    #
    scope :waiting_scope, lambda{|time|joins(:roles).where("accounts.session_id = 0").where("accounts.normal_at <= ? ",time || Time.now).where("accounts.enabled = 1")
    .where(" roles.status = 'normal' and roles.session_id = 0 and roles.online = 0 and roles.today_success = 0").where("roles.level < ?",Setting.role_max_level).reorder("roles.updated_at desc").uniq().readonly(false)}
    #
    scope :bind_scope, where("bind_computer_id > 0") # 已绑定
    scope :waiting_bind_scope, where("bind_computer_id = 0") # 未绑定 ,等待绑定的账户
    scope :unbind_scope ,where("bind_computer_id = -1") # 不能绑定
    scope :un_normal_scope,where("status != 'normal' ") # 非正常状态的账号
    scope :no_server_scope,where("server is null or server = '' ") #服务器为空的账号 
    scope :bind_phone_scope, where("phone_id is not null and phone_id != '' ") # 绑定手机的账号
    scope :unbind_phone_scope, where("phone_id is null || phone_id = '' ") # 未绑定手机的账号
    scope :unlocked_scope,where("unlock_phone_id is not null and unlock_phone_id != '' ") 

    # session_id > 0 表示正在运行
    def is_started?
      return self.session_id > 0
    end

    # 帐号在线，并且在线角色ID > 0 表示正在工作
    def is_working?
      return self.is_started? && self.online_role_id > 0 
    end

    def can_start?
      return self.session_id == 0 && self.today_success == false && (self.normal_at <= Time.now)
    end


    # 开始帐号
    def api_start opts
      # 判断账号是否在线
      return CODES[:account_is_started] if self.is_started?
      ip = Ip.find_or_create(opts[:ip])
      computer = Computer.find_by_auth_key(opts[:ckey])
      self.transaction do
        computer.increment(:online_accounts_count,1).save  #增加计算机上线账号数
        ip.update_attributes(:use_count=>ip.use_count+1,:last_account=>self.no,:cooling_time=>Time.now.since(25.hours)) #增加ip使用次数
        #插入账号开始记录
        tmp = computer.to_note_hash.merge(:account=>self.no,:api_name=>"account_start",:ip=>opts[:ip],:msg=>opts[:msg])
        # 记录 session
        session = Note.create(tmp)
        
        # 可以调度的角色
        @online_roles = opts[:all] ? self.roles : self.roles.waiting_scope.where("roles.level < ?",Setting.role_max_level)
        @online_roles = @online_roles.reorder("role_index").limit(Setting.account_start_roles_count)
        # 调度角色
        @online_roles.each do |role|
            role_note = Note.create(tmp.merge(:role_id => role.id,:session_id=>session.id,:api_name=>"role_online")) # 创建角色 online 记录
            role.update_attributes(:online=>true,:online_note_id=>role_note.id) # 修改角色 session_id
        end
    
        return 1 if self.update_attributes(:session_id=>session.id,:online_ip=>ip.value,:last_start_ip=>ip.value)
      end
    end


    # 同步帐号
    def api_sync opts
      return CODES[:account_is_stopped] unless self.is_started?
      role = self.roles.find_by_id(opts[:rid])
      # 修改角色
      role.api_sync(opts) if role
      #当前会话机器
      return 1 if self.update_attributes(:updated_at => Time.now)
    end

    #
    def api_note opts
      return CODES[:account_is_stopped] unless self.is_started?
      status = opts[:status]
      event = opts[:event]
      
      return 0 unless  (STATUS.has_key? status) || (EVENT.include? event) #事件和状态都未定义，不进行更新
      session = self.session
      computer = session.computer
      api_name = "0",api_code = "0"
      #
      self.transaction do 
        # 记录账户改变的状态
        if STATUS.has_key? status
          api_name = status # 如果定义了有效状态 设置 api_name => status
          api_code = status # 如果定义了有效状态 设置 api_code => status
          self.status = status
          self.normal_at = Time.now.since(Account::STATUS[status].hours)
        end
        # 记录账号发生的事件
        api_name = event if EVENT.include? event # 如果定义了有效事件，设置api_name => event
        #
        if status == 'discardfordays'
            count = Note.where("api_name = 'discardfordays' and computer_id = ? ",computer.id).where("date(created_at)=?",Date.today.to_s).count
            computer.update_attributes(:status=>0) if count >= Setting.account_discardfordays
        
        end
        #
        Note.create do |n|
          n.computer_id = computer.id
          n.hostname = computer.hostname
          n.role_id  =  self.online_role_id
          n.ip = opts[:ip]
          n.api_name  =  api_name
          n.msg = opts[:msg]
          n.account  =  self.no
          n.server  =  self.server
          n.version  =  computer.version
          n.session_id = session.id
          n.api_code = api_code
          #binding.pry
          # if api_name == 'discardforyears'
          #   tmp = opts[:msg] =~ /.*(\d{1,2})月(\d{1,2})日/
          #   n.created_at = DateTime.parse("%.4d%.2d%.2d" % [Time.now.year,$1,$2]) unless tmp.nil? or $1.nil? or $2.nil? 
          # end
        end
         return 1 if self.update_attributes(:updated_at => Time.now)

      end
    end


    # 停止帐号
    def api_stop opts
       # 判断账号是否在线
      return CODES[:account_is_stopped] unless self.is_started?
      
      self.transaction do 
        # 停止已启动的角色
        self.roles.started_scope.each do |role|
          role.api_stop(opts)
        end
        computer = Computer.find_by_id(opts[:cid])
        unless self.session.nil?
          # 当前 session
          session = self.session
          computer = session.computer
        
          # 创建stop 记录
          Note.create(:account => self.no, :computer_id=>computer.id,:ip=>opts[:ip],:api_name=>'account_stop',:msg=>opts[:msg],
           :server => self.server || computer.server,:version => computer.version,:hostname=>computer.hostname,:session_id=>session.id)
         
          # 更新 session    
          now = Time.now
          hours = (now - session.created_at)/3600
        
          #p "=====================#{self.online_role_ids}====#{session.success_role_ids}"
          # 参数成功，或者online 的角色 等于 success 的角色 表示本次会话成功
          at = Time.now
          if opts[:success].to_i ==1
            self.today_success = session.success = true
            at = session.created_at
            at = at.since(1.day) if (6..23).include?(at.hour)
            self.normal_at = at.change(:hour => 6,:min => 0,:sec => 0)
          else
            self.normal_at = Time.now.since(Account::STATUS[self.status].hours) if Account::STATUS.has_key?(status)
          end
          ip = Ip.find_or_create(opts[:ip])
          ip.update_attributes(:cooling_time=>Time.now.since(25.hours))
          # 完成session 
          session.update_attributes(:ending=>true, :stopped_at =>now,:hours=>hours)
        end
       computer.decrement(:online_accounts_count,1).save if computer && computer.online_accounts_count > 0
      # 修改角色 online
       self.roles.update_all(:online => false)
       # 修改账号的session_id 为0 并清空上线 IP
       return 1 if self.update_attributes(:session_id=>0,:online_ip=>nil)
      end
    end


    def api_reg opts,computer
      return CODES[:not_valid_pay] unless self.valid?
      tmp = computer.to_note_hash.merge(:account=>self.no,:api_name=>"account_reg",:ip=>opts[:ip],:msg=>opts[:msg])
      Note.create(tmp)
      self.add_new_role(Setting.account_reg_roles_count)
      return 1 if self.save
    end



    #搜索账号列表
    def self.list_search opts
    	accounts = Account.includes(:session,:bind_computer)
      accounts = accounts.where("no = ?", opts[:no]) unless opts[:no].blank?
    	accounts = accounts.where("server like ?","%#{opts[:server]}%") unless opts[:server].blank?
      accounts = accounts.no_server_scope if opts[:no_server].to_i == 1
    	accounts = accounts.where("status = ?",opts[:status])	unless opts[:status].blank?
      accounts = accounts.where("today_success =?",opts[:ts].to_i) unless opts[:ts].blank?
      accounts = accounts.where("roles_count = ?",opts[:roles_count].to_i) unless opts[:roles_count].blank?
      accounts = accounts.where("bind_computer_id = ?",opts[:bind_cid].to_i) unless opts[:bind_cid].blank?
      accounts = accounts.where(:is_auto => opts[:auto].to_i) unless opts[:auto].blank?
      accounts = accounts.where("phone_id like ?","%#{opts[:phone]}%") unless opts[:phone].blank?
      accounts = accounts.where("normal_at >= ?",opts[:min_nat]) unless opts[:min_nat].blank?
      accounts = accounts.where("normal_at <= ?",opts[:max_nat]) unless opts[:max_nat].blank?
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
      unless opts[:bind_phone].blank?
        accounts = opts[:bind_phone].to_i == 0 ? accounts.unbind_phone_scope : accounts.bind_phone_scope
      end
      accounts = accounts.unlocked_scope unless opts[:unlocked].blank?
      accounts = accounts.where("date(unlocked_at) =? ",opts[:unlocked_at]) unless opts[:unlocked_at].blank?
      # 根据在线IP 查询账户
      accounts = accounts.where("online_ip like ?","%#{opts[:online_ip]}%") unless opts[:online_ip].blank?
      accounts = accounts.where("online_computer_id = ?",opts[:online_cid].to_i) unless opts[:online_cid].blank?
      accounts = accounts.where("date(created_at) = ?",opts["date(created_at)"]) unless opts["date(created_at)"].blank?
      accounts = accounts.where("accounts.enabled = ?",opts[:enabled]) unless opts[:enabled].blank?
      accounts = accounts.where("accounts.in_cpo = ?",opts[:in_cpo]) unless opts[:in_cpo].blank?
    
      return accounts
    end

    def set_online_roles
      @online_roles = self.roles
    end


    def online_role_ids
      self.roles.online_scope.select(:id).reorder("id desc").uniq().map(&:id)
    end

    #为账号新建一个角色
    def add_new_role n,profession=''
      i = self.roles_count
      n.to_i.times.each do 
         self.roles.build(:account=>self.no,:password => self.password,:role_index => i,:vit_power=>156,:server => self.server,:profession=>profession)
        i = i+1
      end
      self.save
    end


    #可用的角色
    def available_roles
      self.roles.where("vit_power > 0 and status = 'normal' ")
    end

    def reorder_roles
      self.roles.reorder("role_index")
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
      #now = Time.now.strftime("%Y-%m-%d %H:%M:%S")
      # 状态为可恢复，并且恢复时间小于当前时间的账号
      #accounts = Account.where("status in (?)",Auto_Normal.keys).where("normal_at <= '#{now}'").reorder(:id)
      #accounts.update_all(:status => "normal",:normal => nil,:updated_at => Time.now)
    end

   # 账号自动停止
   def self.auto_stop
      accounts = Account.started_scope.where("updated_at < ?",30.minutes.ago)
      accounts.each do |account|
        account.api_stop(opts={:cid=>account.online_computer_id,:ip=>"localhost",:msg=>"timeout"})
      end
   end

   # 自动禁用账号的绑定
   def self.auto_unbind

      updated_at = Time.now.ago(48.hours).change(:hour => 6)
      accounts = Account.stopped_scope.bind_scope.where("updated_at <= ? ",updated_at)
      accounts.each do |account|
           account.do_unbind_computer(opts={:ip=>"localhost",:msg=>"auto",:bind=>0}) 
      end
      #
      normal_at = Time.now.since(1000.hours).change(:hour=>6)
      accounts = Account.stopped_scope.where("bind_computer_id != -1").where("normal_at >= ?",normal_at)
      accounts.each do |account|
          account.do_unbind_computer(opts={:ip=>"localhost",:msg=>"auto",:bind=>-1})
      end

   end

   def self.set_bind
      accounts = Account.stopped_scope.bind_scope.where("last_start_at <= ? ",'2014-08-01 00:00:00')
      accounts.each do |account|
           account.do_unbind_computer(opts={:ip=>"localhost",:msg=>"81",:bind=>0})
      end
   end

   #
   def self.auto_cancel_bind
      accounts = Account.stopped_scope.where("bind_computer_id != -1").where("normal_at >= ?",Time.now.since(1000.hours))
      accounts.each do |account|
          if account.bind_computer == nil || account.bind_computer.auto_unbind
            account.do_unbind_computer(opts={:ip=>"localhost",:msg=>"auto",:bind=>-1})
          end
      end
      #
      accounts = Account.stopped_scope.bind_scope.where("normal_at >= ? or updated_at < ? ",Time.now.since(24.hours),Time.now.ago(72.hours))
      accounts.each do |account|
           if account.bind_computer == nil || account.bind_computer.auto_unbind
            account.do_unbind_computer(opts={:ip=>"localhost",:msg=>"auto",:bind=>0})
           end
      end

   end


   # 绑定机器
   def do_bind_computer computer,opts
      return unless computer
      return if self.bind_computer_id != 0
      self.transaction do 
        # 绑定机器
        server = self.server.blank? ? computer.server : self.server 
        self.update_attributes(:bind_computer_id => computer.id,:server => server,:updated_at => Time.now)
        # 修改机器绑定数量
        computer.update_attributes(:accounts_count =>computer.accounts_count+1)
        # 插入记录
        note = Note.create(:account => self.no, :computer_id=>computer.id || 0,:ip=>opts[:ip],:api_name=>'bind_computer',:msg=>opts[:msg],
           :server => self.server || computer.server,:version => computer.version,:hostname=>computer.hostname)
      end
   end


   # 禁用绑定
   def do_unbind_computer opts
      bind = opts[:bind].to_i
      return if bind != -1 && bind != 0
      computer = self.bind_computer
      self.transaction do 

        #return unless computer.auto_unbind
        # 禁用绑定
        self.update_attributes(:bind_computer_id => bind,:updated_at => Time.now)
        return unless computer

        # 修改机器的账号数量
        computer.update_attributes(:accounts_count=>computer.accounts_count-1) if computer.accounts_count > 0
        # 默认IP
        opts[:ip] = "localhost" if opts[:ip].blank?
        api_name=  bind == 0 ? "cancel_bind" : "disable_bind"
        # 插入记录
        note = Note.create(:account => self.no, :computer_id=>computer.id || 0,:ip=>opts[:ip],:api_name=>api_name,:msg=>opts[:msg],
             :server => self.server || computer.server,:version => computer.version,:hostname=>computer.hostname,:api_code=>bind)
      end
   end

   def self.reset_today_success
      Account.where(:today_success=>true).update_all(:today_success => false)
   end


   def max_role_level
      return self.roles.maximum("level")
   end

    #
    def sellers
      return [] unless self.real_server
      return  self.real_server.roles
    end

    def sell_goods
      return "" unless self.real_server
      return  self.real_server.goods
    end

    def goods_price
      return 1 unless self.real_server
      return  self.real_server.price
    end

    def real_server
      return self.game_server if self.game_server
      tmp = self.server.split("|")
      return Server.find_by_name(tmp[0]) if tmp.length == 2
    end


    def is_bind_phone
      return !self.phone_id.blank?
    end

    def was_unlocked
      return !self.unlock_phone_id.blank?
    end

    def helpers
      Role.started_scope.where(:is_helper=>true,:server=>self.server)
    end

    def helper_role 
      role = Role.started_scope.where(:is_helper=>true,:server=>self.server).first
    end

    def format_string
      return "#{self.no}----#{self.password}----#{self.phone_id}----#{self.status}----#{self.server}"
    end

    def phone_id
      return ''
    end

    before_create :init_data

    def init_data
      self.normal_at = Time.now
    end
    

end
