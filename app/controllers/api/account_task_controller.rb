# encoding: utf-8
# @suxu "2727260443","password":"xyz987987
# 
class Api::AccountTaskController < Api::BaseController

	def get
	end

	def end
		at = AccountTask.where("account = ?",params[:id]).where("event = ?",params[:event]).first
		at.update_attributes(:status=>"finished") if at
		render :json => {:code => 1}
	end

end