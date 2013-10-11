class Note < ActiveRecord::Base

	belongs_to :computer
	belongs_to :role
	#belongs_to :ip ,:class_name => 'ip'
	#
    attr_accessible :user_id, :role_id,:computer_id,:api_name,:api_code,:ip,:msg,:online_at,:online_note_id,:online_hours,:level,:version,:account,:server
    attr_accessible :hostname

    default_scope :order => 'id DESC'


    scope :time_scope,lambda{|start_time,end_time|where(created_at: start_time..end_time)}

    scope :online_at_scope,lambda{|start_time,end_time|where(online_at: start_time..end_time)}

    scope :day_scope,lambda{|time|time_scope(time,time+1.day)}
    
    scope :event_scope, lambda{|event|where(:api_name => event)}



end
