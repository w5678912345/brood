class Note < ActiveRecord::Base

	belongs_to :computer
	belongs_to :role
	#belongs_to :ip ,:class_name => 'ip'
	#
    attr_accessible :user_id, :role_id,:computer_id,:api_name,:api_code,:ip

    default_scope :order => 'id DESC'

    scope :online_scope, where(:api_name => "online")

    scope :offline_scope, where(:api_name => "offline")

    scope :sync_scope, where(:api_name => "sync")

    scope :close_scope, where(:api_name => "close")

    scope :reg_scope, where(:api_name => "reg")

    

  def ip_url
  	self.ip.gsub(".","_")
  end
end
