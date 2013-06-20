# encoding: utf-8
class Payment < ActiveRecord::Base
		
		attr_accessible :role_id,:gold,:balance,:pay_type,:remark,:note_id
		#
		belongs_to :role
		belongs_to :note
		#
	 	validates_presence_of :role_id, :gold, :balance, :pay_type ,:note_id
		validates_numericality_of :gold, :only_integer => true, :greater_than_or_equal_to => 0
		validates_numericality_of :balance, :only_integer => true, :greater_than_or_equal_to => 0
		
		validates_length_of :remark, :maximum => 200
		
		default_scope :order => 'id DESC'
		

		# select role_id, sum(gold) from payments group by pay_type;
		# select pay_type, sum(gold) from payments group by pay_type;
end