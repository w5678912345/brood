# encoding: utf-8
class Account < ActiveRecord::Base

    STATUS = ['normal','bslocked','closed','exception','locked','lost','online','discard','NoRmsFile','NoQQToken']

    # 
    attr_accessible :no, :password,:server,:online_role_id,:online_computer_id,:online_note_id,:online_ip,:status

	  belongs_to :game_server, :class_name => 'Server', :foreign_key => 'server',:primary_key => 'name'

    belongs_to :online_role, :class_name => 'Role', :foreign_key => 'online_role_id'


   	belongs_to :online_note, :class_name => 'Note', :foreign_key => 'online_note_id'
   	
   	belongs_to :online_computer, :class_name => 'Computer', :foreign_key => 'online_computer_id'
    
    has_many   :roles, :class_name => 'Role', :foreign_key => 'account', :primary_key => 'no'

    has_many :computer_accounts,:dependent => :destroy,:foreign_key => 'account_no', :primary_key => 'no'

    has_many   :computers,:class_name => 'Computer',through: :computer_accounts


    validates_uniqueness_of :no

    default_scope order("online_note_id desc")
    #scope :online_scope,where("online_computer_id > 0")
    #scope :offline_scope,where("online_computer_id = 0")


    def is_online?
      return self.status == 'online'
    end



    # 获取当前帐号
    def api_get opts
      ip = Ip.find_or_create(opts[:ip])
      computer = Computer.find_by_auth_key(opts[:ckey])
      self.transaction do
        computer.update_attributes(:online_accounts_count=>computer.online_accounts_count+1,:version=>opts[:version]|| opts[:msg]) 
        ip.update_attributes(:use_count=>ip.use_count+1)
        note = Note.create(:computer_id=>computer.id,:ip=>ip.value,:api_name=>"online",:msg=>opts[:msg],:account => self.no,:server => self.server,:version => computer.version)
        return 1 if self.update_attributes(:online_ip=>ip.value,:online_computer_id=>computer.id,:online_note_id => note.id,:status=>'online')
      end
    end


    # 设置当前帐号 属性
    def api_set opts
      computer = Computer.find_by_auth_key(opts[:ckey])
      status = opts[:event]
      self.transaction do 
        self.status = status
        note = Note.create(:role_id => self.online_role_id, :computer_id=>computer.id,:ip=>opts[:ip],:api_name=>opts[:event],:msg=>opts[:msg],:account => self.no,:server => self.server,:version => computer.version)
        return 1 if self.save
      end
    end


    # 放回当前帐号
    def api_put opts
      computer = Computer.find_by_auth_key(opts[:ckey])
      self.transaction do 
        #
       note = Note.create(:role_id => self.online_role_id, :computer_id=>computer.id,:ip=>opts[:ip],:api_name=>'offline',:msg=>opts[:msg],:account => self.no,:server => self.server,:version => computer.version)
       return 1 if self.update_attributes(:online_ip=>nil,:online_computer_id=>0,:online_note_id => 0,:online_role_id => 0,:status => 'normal')
      end
    end




    def self.list_search opts
    	accounts = Account.includes(:online_computer,:online_role)
      accounts = accounts.where("no = ?", opts[:no]) unless opts[:no].blank?
    	accounts = accounts.where("server = ?",opts[:server]) unless opts[:server].blank?
    	accounts = accounts.where("status = ?",opts[:status])	unless opts[:status].blank?
      accounts = accounts.where("roles_count = ?",opts[:roles_count].to_i) unless opts[:roles_count].blank?
      accounts = accounts.where("computers_count = ?",opts[:computers_count].to_i) unless opts[:computers_count].blank?
      accounts = accounts.where("date(created_at) = ?",opts["date(created_at)"]) unless opts["date(created_at)"].blank?
      return accounts
    end

    def self.get_well_account opts

    end



    def sellers
      return  self.game_server.roles
    end

    def sell_goods
      return  self.game_server.goods
    end

    def goods_price
      return  self.game_server.price
    end

end
