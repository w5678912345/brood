# encoding: utf-8
module Gold
class HomeController < AppController

	def show
		
		@role_count = Role.where("total > 0").count
		@sum_balance = Role.where("gold > 0").sum(:gold)
		@sum_payment = Payment.sum(:gold)
		@sum_payment_trade = Payment.where(:pay_type=>"trade").sum(:gold)
	end

end
end