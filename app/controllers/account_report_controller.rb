# encoding: utf-8
class AccountReportController < ActionController::Base
	def show
		ss = ['normal','bslocked','discardforyears','discardbysailia']
		@records = Account.select("server,
			COUNT(if(status='normal' or status='delaycreate',no,null)) as normal_count,
			COUNT(if(status='bslocked',no,null)) as bs_count,
			COUNT(if(status='discardforyears',no,null)) as discard_count,
			COUNT(if(status='discardbysailia',no,null)) as sailia_count,
			COUNT(if(status <> 'delaycreate' and status <> 'normal' and status <> 'bslocked' and status <> 'discardforyears' and status <> 'discardbysailia',no,null)) as other_count
			").group("server")

		@ticket_records = TicketRecord.server_data
		
	end
	def accounts
		@accounts = initialize_grid(Account,:include => [:bind_computer,:account_session])
	end
end