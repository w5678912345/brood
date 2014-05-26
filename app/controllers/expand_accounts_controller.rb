class ExpandAccountsController < ApplicationController



	def edit_enabled
		@ids = params[:grid][:selected] || []
	end

	def update_enabled
		@ids = params[:ids] || []
	    i = Account.where("no in (?)",@ids).update_all(:enabled => params[:enabled])
	    flash[:msg] = "#{i} accounts was enabled updated"
	    redirect_to accounts_path
	end


	def edit_in_cpo
		@ids = params[:grid][:selected] || []
		@accounts = Account.where("no in (?)",@ids)
	end

	def update_in_cpo
		@ids = params[:ids] || []
		i = @accounts = Account.where("no in (?)",@ids).update_all(:enabled => false,:in_cpo=>true)
		flash[:msg] = "#{i} 个账号导入到CPO"
		redirect_to accounts_path
	end



end