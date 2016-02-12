# encoding: utf-8
class Payment < ActiveRecord::Base
		
		attr_accessible :role_id,:gold,:balance,:pay_type,:remark,:note_id,:server,:target
		#attr_accessor		:max_total,:min_total
		#
		belongs_to :role
		belongs_to :note
		#
	 	validates_presence_of :role_id, :gold, :balance, :pay_type ,:note_id
		validates_numericality_of :gold, :only_integer => true, :greater_than_or_equal_to => 0
		validates_numericality_of :balance, :only_integer => true, :greater_than_or_equal_to => 0
		
		validates_length_of :remark, :maximum => 200
		#
		#default_scope :order => 'id DESC'
		scope :order_id_desc , order("id DESC")
		scope :at_date,lambda{|day| where(created_at: day.beginning_of_day..day.end_of_day)}
		scope :trade_scope,where(:pay_type => "trade")
		scope :pay_type_scope,lambda {|pay_type|where(:pay_type => pay_type )}
		#
		scope :total_group_role_scope,includes(:role).select("role_id,max(total) as total").group("role_id")

		scope :time_scope,lambda{|start_time,end_time|where(created_at: start_time..end_time)}
		

		# select role_id, sum(gold) from payments group by pay_type;
		# select pay_type, sum(gold) from payments group by pay_type;
		#SELECT max(total) as total FROM `payments` GROUP BY role_id ORDER BY id DESC

		
		def self.total_count
				#Payment.select("max(total) as total").group("role_id")
		end

		
		def self.real_pay
			all_roles = TopSell.all.map &:role_name
			self.where(target: all_roles)
		end
end
