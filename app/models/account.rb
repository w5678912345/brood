class Account < ActiveRecord::Base
    attr_accessible :no, :password,:server

	  belongs_to :online_role, :class_name => 'Role', :foreign_key => 'online_role_id'

   	belongs_to :online_note, :class_name => 'Note', :foreign_key => 'online_note_id'
   	
   	belongs_to :online_computer, :class_name => 'Computer', :foreign_key => 'online_computer_id'
    
    has_many   :roles, :class_name => 'Role', :foreign_key => 'account', :primary_key => 'number'


    validates_uniqueness_of :no

    scope :online_scope,where("online_computer_id > 0")
    scope :offline_scope,where("online_computer_id = 0")


    def self.list_search opts
    	accounts = Account.includes(:online_computer)
      accounts = accounts.where("no =? ", opts[:no]) unless opts[:no].blank?
    	accounts = accounts.where("server =? ",opts[:server]) unless opts[:server].blank?
    	accounts = accounts.where("status =? ",opts[:status])	unless opts[:status].blank?
      accounts = accounts.where("date(created_at) =?",opts["date(created_at)"]) unless opts["date(created_at)"].blank?
      unless opts[:online].blank?
        accounts = opts[:online].to_i == 1 ? accounts.online_scope : accounts.offline_scope
      end
      return accounts
    end

end
