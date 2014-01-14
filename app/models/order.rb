# encoding: utf-8
class Order < ActiveRecord::Base
    
    attr_accessible :phone_no, :account_no,:trigger_event, :pulled, :pulled_at

	belongs_to :phone, :class_name => 'Phone', :foreign_key => 'phone_no',:primary_key => 'no'

	belongs_to :account, :class_name => 'Account', :foreign_key => 'account_no', :primary_key => 'no'




end
