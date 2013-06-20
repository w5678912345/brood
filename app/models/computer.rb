# encoding: utf-8
class Computer < ActiveRecord::Base
  attr_accessible :hostname, :auth_key,:status,:user_id,:roles_count
	attr_accessible :check_user_id,:checked,:checked_at
  belongs_to :user
	belongs_to :check_user,:class_name => 'user'
  has_many :roles
  has_many :notes

  default_scope :order => 'id DESC'
  
  validates_presence_of :hostname,:auth_key,:user_id
  validates_uniqueness_of :auth_key


	def check opts
			self.checked = opts[:checked]
			
	end

	def uncheck
			self.checked = false
			#self.check_user 
	end
  
end
