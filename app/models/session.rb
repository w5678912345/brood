# encoding: utf-8
class Session < ActiveRecord::Base
	#
	attr_accessible :computer_id, :account, :role_id, :ip,:hostname,:server,:version
	attr_accessible	:sup_id, :ending, :end_at, :hours, :status,:updated_at
	attr_accessible :role_start_level,:role_end_level,:success

	#
	belongs_to :computer
    belongs_to :qq_account, :class_name => 'Account',:foreign_key=>'account',:primary_key=>'no'
	belongs_to :role

	#
	scope :accounts_scope, where("account is not null and role_id = 0") #
	scope :roles_scope, where("account is not null and role_id > 0 ") #


	def self.list_search opts
		sessions = Session.includes(:role,:computer,:qq_account)
		sessions = sessions.where(:ending=>opts[:end].to_i) unless opts[:end].blank?
		sessions = sessions.where(:success=>opts[:success].to_i) unless opts[:success].blank?
		sessions = sessions.where("created_at >= ?",opts[:start_date]) unless opts[:start_date].blank?
		sessions = sessions.where("created_at <= ?",opts[:end_date]) unless opts[:end_date].blank?
		return sessions
	end

end