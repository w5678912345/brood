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
			all_roles = all_roles + get_direct_agents_names
			self.where(target: all_roles)
		end
		def self.get_direct_agents_names
			name_table = {"广州1/2区"=>"据说筒瓦",
							"重庆2区"=>"雪白小",
							"四川3区"=>"明天会更",
							"湖南3区"=>"绝缘体冷",
							"四川6区"=>"徒步者张永博",
							"华北4区"=>"我爱足",
							"河北4区"=>"侯广安一水间",
							"北京2/4区"=>"乐饱饱坐",
							"北京1区"=>"豚豚蓝海海",
							"河南2区"=>"非小虫不",
							"河南3区"=>"小圆圈小霞",
							"河南4区"=>"瑶瑶雪兰花",
							"河北1区"=>"桃子红",
							"华北3区"=>"绿豆角坏一点",
							"河南6区"=>"另一种醉笨",
							"华北1区"=>"相当凑合阿玲",
							"浙江1区"=>"来学习的想念",
							"广东1区"=>"断点化龙雷",
							"广西2/4区"=>"阿德里问问吧",
							"广东4区"=>"叶凌薰窦豆",
							"湖北2区"=>"艾远芳芝",
							"广东8区"=>"白鹭精",
							"安徽3区"=>"捕风者馨香晚",
							"广东3区"=>"计算机宓子"}
		return name_table.values
	end
end
