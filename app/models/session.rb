# encoding: utf-8
class Session < ActiveRecord::Base
	#
	attr_accessible :computer_id, :account, :role_id, :ip,:hostname,:server,:version
	attr_accessible	:sup_id, :ending, :end_at, :hours, :status

	#
	belongs_to :computer
    belongs_to :qq_account, :class_name => 'Account',:foreign_key=>'account',:primary_key=>'no'
	belongs_to :role

	#
	scope :accounts_scope, where("account is not null and role_id = 0") #
	scope :roles_scope, where("account is not null and role_id > 0 ") #

end