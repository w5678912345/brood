# encoding: utf-8
class ComputerAccount < ActiveRecord::Base

  attr_accessible :computer_id,:account_no

  belongs_to :account, :class_name => 'Account' ,:foreign_key => 'account_no', :primary_key => 'no', :counter_cache => :computers_count
  belongs_to :computer, :class_name => 'Computer' #,:counter_cache => :accounts_count

  validates_uniqueness_of :account_no, :scope => :computer_id

end
