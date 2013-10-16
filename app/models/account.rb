# encoding: utf-8
class Account < ActiveRecord::Base

    STATUS = ['normal','bslocked','bslocked_again','disconnect','exception','locked','lost','discard','no_rms_file','no_qq_token','finished']
    EVENT = ['hello']

    # 
    attr_accessible :no, :password,:server,:online_role_id,:online_computer_id,:online_note_id,:online_ip,:status
    attr_accessible :bind_computer_id, :bind_computer_at
    #所属服务器
	  belongs_to :game_server, :class_name => 'Server', :foreign_key => 'server',:primary_key => 'name'

    #在线角色
    belongs_to :online_role, :class_name => 'Role', :foreign_key => 'online_role_id'
    #在线记录
   	belongs_to :online_note, :class_name => 'Note', :foreign_key => 'online_note_id'
    #在线机器
   	belongs_to :online_computer, :class_name => 'Computer', :foreign_key => 'online_computer_id' #, :counter_cache => :online_accounts_count
    #绑定机器
    belongs_to :bind_computer,  :class_name => 'Computer', :foreign_key => 'bind_computer_id' #, :counter_cache => :accounts_count
    #包含角色
    has_many   :roles, :class_name => 'Role', :foreign_key => 'account', :primary_key => 'no'

    #has_many :computer_accounts,:dependent => :destroy,:foreign_key => 'account_no', :primary_key => 'no'

    #has_many   :computers,:class_name => 'Computer',through: :computer_accounts


    validates_uniqueness_of :no

    default_scope order("online_note_id desc")
    scope :online_scope,joins(:roles).where("accounts.online_note_id > 0").where("roles.vit_power > 0")
    scope :unline_scope,where("online_note_id = 0")
    #
    scope :bind_scope, where("bind_computer_id > 0")
    scope :unbind_scope, where("bind_computer_id = 0")



    # 在线记录ID >0 并且 在线机器ID > 0 表示帐号在线
    def is_online?
      return self.online_note_id > 0 && self.online_computer_id > 0
    end

    # 帐号在线，并且在线角色ID > 0 表示正在工作
    def working
      return self.is_online? && self.online_role_id > 0 
    end



    # 获取当前帐号
    def api_get opts
      ip = Ip.find_or_create(opts[:ip])
      computer = Computer.find_by_auth_key(opts[:ckey])
      self.transaction do
        computer.update_attributes(:online_accounts_count=>computer.online_accounts_count+1,:version=>opts[:version]|| opts[:msg]) 
        ip.update_attributes(:use_count=>ip.use_count+1)
        note = Note.create(:computer_id=>computer.id,:hostname=>computer.hostname,:ip=>ip.value,:api_name=>"online",
          :msg=>opts[:msg],:account => self.no,:server => self.server,:version => computer.version)
        return 1 if self.update_attributes(:online_ip=>ip.value,:online_computer_id=>computer.id,:online_note_id => note.id)
      end
    end


    # 设置当前帐号 属性
    def api_set opts
      computer = Computer.find_by_auth_key(opts[:ckey])
      status = opts[:status]
      event = opts[:event]
      #return 0 unless STATUS.include? status 
      self.transaction do 
        #self.online_role_id = opts[:rid] unless opts[:rid].blank?
        #
        if STATUS.include? status
          self.status = (self.status == 'bslocked' && status == 'bslocked') ? 'bslocked_again' : status
          if self.status_changed?
            Note.create(:role_id => self.online_role_id, :computer_id=>computer.id,:hostname=>computer.hostname,:ip=>opts[:ip],:api_name=>self.status,
              :msg=>opts[:msg],:account => self.no,:server => self.server,:version => computer.version)
          end
        end

        #   
        if EVENT.include? opts[:event]
          Note.create(:role_id => self.online_role_id, :computer_id=>computer.id,:hostname=>computer.hostname,:ip=>opts[:ip],:api_name => 'default',
          :msg=>opts[:msg],:account => self.no,:server => self.server,:version => computer.version,:api_code=>opts[:event])
        end 
        return 1 if self.save
      end
    end


    # 放回当前帐号
    def api_put opts
      computer = Computer.find_by_auth_key(opts[:ckey])
      computer = Computer.find_by_id(opts[:cid]) unless computer
      self.transaction do 
       note = Note.create(:role_id => self.online_role_id, :computer_id=>computer.id,:hostname=>computer.hostname,:ip=>opts[:ip],:api_name=>'offline',:msg=>opts[:msg],
        :account => self.no,:server => self.server,:version => computer.version)
       return 1 if self.update_attributes(:online_ip=>nil,:online_computer_id=>0,:online_note_id => 0,:online_role_id => 0)
      end
    end




    def self.list_search opts
    	accounts = Account.includes(:online_computer,:online_role,:bind_computer)
      accounts = accounts.where("no = ?", opts[:no]) unless opts[:no].blank?
    	accounts = accounts.where("server = ?",opts[:server]) unless opts[:server].blank?
    	accounts = accounts.where("status = ?",opts[:status])	unless opts[:status].blank?
      accounts = accounts.where("roles_count = ?",opts[:roles_count].to_i) unless opts[:roles_count].blank?
      accounts = accounts.where("online_computer_id = ?",opts[:online_cid].to_i) unless opts[:online_cid].blank?
      accounts = accounts.where("bind_computer_id = ?",opts[:bind_cid].to_i) unless opts[:bind_cid].blank?
      accounts = accounts.where("date(created_at) = ?",opts["date(created_at)"]) unless opts["date(created_at)"].blank?
      return accounts
    end

    def self.get_well_account opts

    end



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
