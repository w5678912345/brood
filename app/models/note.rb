class Note < ActiveRecord::Base

	belongs_to :computer
	belongs_to :role
	#belongs_to :ip ,:class_name => 'ip'
	#
    attr_accessible :user_id, :role_id,:computer_id,:api_name,:api_code,:ip

    default_scope :order => 'id DESC'


  def ip_url
  	self.ip.gsub(".","_")
  end
end
