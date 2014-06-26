# encoding: utf-8
class GoldController < ApplicationController
	
	def show
		@payments = Payment.select("server,sum(gold) as zhuanzhang").where(:pay_type=>"trade").group("server")
		@sum_gold = Payment.sum(:gold)
		@sum_balance = Role.where("gold > 0").sum(:gold)
	end


	def new

	end

	def transfer
		@payments = Payment.select("server,sum(gold) as zhuanzhang").group("server")
	end

end