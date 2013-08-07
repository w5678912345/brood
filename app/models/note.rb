class Note < ActiveRecord::Base

	belongs_to :computer
	belongs_to :role
	#belongs_to :ip ,:class_name => 'ip'
	#
    attr_accessible :user_id, :role_id,:computer_id,:api_name,:api_code,:ip,:msg

    default_scope :order => 'id DESC'

    # scope :online_scope, where(:api_name => "online")

    # scope :offline_scope, where(:api_name => "offline")

    # scope :sync_scope, where(:api_name => "sync")

    # scope :close_scope, where(:api_name => "close")

    # scope :reg_scope, where(:api_name => "reg")

    #scope :time_scope,  where(())


    scope :time_scope,lambda{|start_time,end_time|where(created_at: start_time..end_time)}

    scope :day_scope,lambda{|time|time_scope(time,time+1.day)}
    
    scope :event_scope, lambda{|event|where(:api_name => event)}



end
