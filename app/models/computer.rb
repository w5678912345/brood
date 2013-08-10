# encoding: utf-8
class Computer < ActiveRecord::Base
  attr_accessible :hostname, :auth_key,:status,:user_id,:roles_count
  attr_accessible :check_user_id,:checked,:checked_at,:server,:updated_at,:version
  belongs_to :user
  belongs_to :check_user,:class_name => 'user'
  has_many :roles
  has_many :notes,:dependent => :destroy, :order => 'id DESC'

  default_scope :order => 'server DESC'

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
  
end
