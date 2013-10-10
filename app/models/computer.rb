# encoding: utf-8
class Computer < ActiveRecord::Base
  attr_accessible :hostname, :auth_key,:status,:user_id,:roles_count,:started
  attr_accessible :check_user_id,:checked,:checked_at,:server,:updated_at,:version,:online_roles_count,:online_accounts_count
  has_many :comroles,:dependent => :destroy
  has_many :computer_accounts,:dependent => :destroy

  belongs_to :user
  belongs_to :check_user,:class_name => 'user'
  #has_many :online_roles,:class_name => 'Role',:con

  has_many :roles,:class_name => 'Role', through: :comroles
  has_many :accounts, :class_name => 'Account', through: :computer_accounts

  has_many :notes,:dependent => :destroy, :order => 'id DESC'


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


  def self.reset_roles_count
    computers = Computer.all
    computers.each do |c|
      c.roles_count = c.roles.count
      c.save
    end
  end

  def find_or_create_server
    return @_server if @_server
    @_server = Server.find_by_name(self.server)
    @_server = Server.create(:name=>self.server) unless @_server
    return @_server
  end
  
end
