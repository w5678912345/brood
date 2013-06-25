# encoding: utf-8
class Payment < ActiveRecord::Base
		
		attr_accessible :role_id,:gold,:balance,:pay_type,:remark,:note_id
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
		scope	:pay_type_scope,lambda {|pay_type|where(:pay_type => pay_type )}
		#
		scope :total_group_role_scope,includes(:role).select("role_id,max(total) as total").group("role_id")
		

		# select role_id, sum(gold) from payments group by pay_type;
		# select pay_type, sum(gold) from payments group by pay_type;
		#SELECT max(total) as total FROM `payments` GROUP BY role_id ORDER BY id DESC

		
		def self.total_count
				#Payment.select("max(total) as total").group("role_id")
		end

		

end
