# encoding: utf-8
class Account < ActiveRecord::Base
    CODES = Api::CODES
    # 账号可能发生的状态
    STATUS = ['normal','bslocked','bslocked_again','bs_unlock_fail','bs_unlock_success','disconnect','exception','locked','lost','discard','no_rms_file','no_qq_token','finished']
    # 账号可能发生的事件
    EVENT = []
    Btns = { "disable_bind"=>"禁用绑定","clear_bind"=>"启用绑定","add_role" => "添加角色","call_offline"=>"调用下线"}
    # 需要自动恢复normal的状态
    Auto_Normal = {"disconnect"=>2,"exception"=>3,"bslocked"=>72,"bs_unlock_fail"=>72}
    # 
    attr_accessible :no, :password,:server,:online_role_id,:online_computer_id,:online_note_id,:online_ip,:status
    attr_accessible :bind_computer_id, :bind_computer_at,:roles_count
    #所属服务器
	  belongs_to :game_server, :class_name => 'Server', :foreign_key => 'server',:primary_key => 'name'
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

    default_scope order("online_note_id desc")
    scope :online_scope, where("online_note_id > 0") #
    #
    scope :unline_scope, where("online_note_id = 0").reorder("updated_at desc") # where(:status => 'normal')
    #
    scope :waiting_scope, joins(:roles).where("accounts.online_note_id = 0 and accounts.status = 'normal'").where("roles.vit_power > 0 and roles.status = 'normal' ").readonly(false)
    scope :bind_scope, where("bind_computer_id > 0") # 已绑定
    scope :unbind_scope, where("bind_computer_id = 0") # 未绑定 
    scope :can_not_bind_scope ,where("bind_computer_id = -1") # 不能绑定
    scope :un_normal_scope,where("status != 'normal' ") # 非正常状态的账号
    scope :no_server_scope,where("server is null or server = '' ") #服务器为空的账号 



    # 在线记录ID >0 并且 在线机器ID > 0 表示帐号在线
    def is_online?
      return self.online_note_id > 0 && self.online_computer_id > 0
    end

    # 帐号在线，并且在线角色ID > 0 表示正在工作
    def is_working?
      return self.is_online? && self.online_role_id > 0 
    end



    # 获取当前帐号
    def api_get opts
      # 判断账号是否在线
      return CODES[:account_is_online] if self.is_online?
      ip = Ip.find_or_create(opts[:ip])
      computer = Computer.find_by_auth_key(opts[:ckey])
      self.transaction do
        #增加计算机上线账号数
        computer.update_attributes(:online_accounts_count=>computer.online_accounts_count+1,:version=>opts[:version]|| opts[:msg]) 
        #增加ip使用次数
        ip.update_attributes(:use_count=>ip.use_count+1)
        # 记录note
        note = Note.create(:computer_id=>computer.id,:hostname=>computer.hostname,:ip=>ip.value,:api_name=>"account_online",
          :msg=>opts[:msg],:account => self.no,:server => computer.server,:version => computer.version)
        # 修改账号 上线IP, 上线机器ID, 上线记录ID
        return 1 if self.update_attributes(:online_ip=>ip.value,:online_computer_id=>computer.id,:online_note_id => note.id)
      end
    end


    # 设置当前帐号 属性
    def api_set opts
      computer = Computer.find_by_key_or_id(opts[:ckey] || opts[:cid])
      status = opts[:status]
      event = opts[:event]

      self.transaction do 
        # 记录账户改变的状态
        if STATUS.include? status
          self.status = (self.status == 'bslocked' && status == 'bslocked') ? 'bslocked_again' : status
          if self.status_changed?
            Note.create(:computer_id=>computer.id,:hostname=>computer.hostname,:ip=>opts[:ip],:api_code=>self.status,
              :msg=>opts[:msg],:account => self.no,:server => self.server,:version => computer.version,:api_name => '0')
          end
          #
          if Auto_Normal.has_key?(status)
            #  修改恢复时间
            self.normal_at = Time.now.since(Account::Auto_Normal[status].hours)
          end
        end
        self.normal_at = nil if self.status == 'normal' #状态正常时，清空normal
        self.updated_at = Time.now

        # 记录账号发生的事件
        if EVENT.include? event
          Note.create(:computer_id=>computer.id,:hostname=>computer.hostname,:ip=>opts[:ip],:api_name => opts[:event],
          :msg=>opts[:msg],:account => self.no,:server => self.server,:version => computer.version)
        end 
        return 1 if self.save
      end
    end


    # 放回当前帐号
    def api_put opts
      # 判断账号是否在线
      return CODES[:account_is_offline] unless self.is_online?
      computer = Computer.find_by_key_or_id(opts[:ckey] || opts[:cid])
      computer = Computer.new unless computer
      self.transaction do 
       # 修改机器的上线账号数量
       computer.update_attributes(:online_accounts_count=>computer.online_accounts_count-1) if computer.online_accounts_count > 0
       #
       # 更新 在线时间
       
       # 记录 note
       note = Note.create(:computer_id=>computer.id,:ip=>opts[:ip],:api_name=>'account_offline',:msg=>opts[:msg],
        :account => self.no,:server => self.server || computer.server,:version => computer.version,:hostname=>computer.hostname)
       # 修改账号的 上线IP, 上线机器ID, 上线记录ID, 上线角色ID
       return 1 if self.update_attributes(:online_ip=>nil,:online_computer_id=>0,:online_note_id => 0,:online_role_id => 0)
      end
    end



    #搜索账号列表
    def self.list_search opts
    	accounts = Account.includes(:online_computer,:online_role,:bind_computer)
      accounts = accounts.where("no = ?", opts[:no]) unless opts[:no].blank?
    	accounts = accounts.where("server = ?",opts[:server]) unless opts[:server].blank?
      accounts = accounts.no_server_scope if opts[:no_server].to_i == 1
    	accounts = accounts.where("status = ?",opts[:status])	unless opts[:status].blank?
      accounts = accounts.where("roles_count = ?",opts[:roles_count].to_i) unless opts[:roles_count].blank?
      accounts = accounts.where("bind_computer_id = ?",opts[:bind_cid].to_i) unless opts[:bind_cid].blank?
      #
      unless opts[:online].blank?
        accounts = opts[:online].to_i == 1 ? accounts.online_scope : accounts.unline_scope
      end
      unless opts[:bind].blank?
        accounts = accounts.bind_scope if opts[:bind] == 'bind'
        accounts = accounts.unbind_scope if opts[:bind] == '0'
        accounts = accounts.can_not_bind_scope if opts[:bind] == '-1'
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

    #为账号新建一个角色
    def add_new_role
      self.roles.build(:account=>self.no,:password => self.password,:role_index => self.roles.count,:vit_power=>156,:server => self.server)
      self.save
    end


    #账号自动恢复normal 状态
    def self.auto_normal
      now = Time.now.strftime("%Y-%m-%d %H:%M:%S")
      # 状态为可恢复，并且恢复时间小于当前时间的账号
      accounts = Account.where("status in (?)",Auto_Normal.keys).where("normal_at <= '#{now}'").reorder(:id)
      accounts.update_all(:status => "normal",:normal => nil)
    end

    #可用的角色
    def available_roles
      self.roles.where("vit_power > 0 and status = 'normal' ")
    end

    def self.reset_roles_count
      accounts = Account.all
      accounts.each do |account|
        account.update_attributes(:roles_count => account.roles.count)
      end
    end


    def self.auto_disable_bind
      time = Time.now.ago(2.day)
      accounts = Account.where("updated_at < ?",time)
      accounts.update_all(:bind_computer_id => -1)
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
