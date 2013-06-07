# encoding: utf-8
class Computer < ActiveRecord::Base
  attr_accessible :hostname, :auth_key,:status,:user_id,:roles_count
  belongs_to :user
  has_many :roles

  default_scope :order => 'id DESC'
  
  validates_presence_of :hostname,:auth_key,:user_id
  validates_uniqueness_of :auth_key
  
end
