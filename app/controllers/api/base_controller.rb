# encoding: utf-8
# @suxu
# 
class Api::BaseController < ActionController::Base
	layout :nil
	CODES = Api::CODES

	def readme
    	render :layout => 'application',:template => 'api/readme'
  	end

end