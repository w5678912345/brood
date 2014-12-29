# encoding: utf-8
class AccountReportController < ActionController::Base
	def show
		@records = Account.select("server,
			COUNT(if(status='normal',no,null)) as normal_count,
			COUNT(if(status='bslocked',no,null)) as bs_count,
			COUNT(if(status='discardforyears',no,null)) as discard_count,
			COUNT(if(status='discardbysailia',no,null)) as sailia_count
			").group("server")
	end
end