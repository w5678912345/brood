# encoding: utf-8
class Note < ActiveRecord::Base

	belongs_to :computer
    belongs_to  :qq_account, :class_name => 'Account',:foreign_key=>'account',:primary_key=>'no'
	belongs_to :role
	#
    attr_accessible :user_id, :role_id, :computer_id, :api_name, :api_code, :ip, :msg, :online_at, :online_note_id, :online_hours
    attr_accessible :level, :version, :account, :server, :hostname
    #
    default_scope :order => 'id DESC'

    scope :time_scope,lambda{|start_time,end_time|where(created_at: start_time..end_time)}

    scope :online_at_scope,lambda{|start_time,end_time|where(online_at: start_time..end_time)}

    scope :day_scope,lambda{|time|time_scope(time,time+1.day)}
    
    scope :event_scope, lambda{|event|where(:api_name => event)}


    #
    def self.list_search opts

    end

end
