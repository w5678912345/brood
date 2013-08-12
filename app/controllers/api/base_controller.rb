# encoding: utf-8
# @suxu
# 
class Api::BaseController < ActionController::Base
	layout :nil
	CODES = Api::CODES

	before_filter :print_log

	def readme
    	render :layout => 'application',:template => 'api/readme'
  	end

  	private 
  	def print_log
  		base = "#{request.protocol}#{request.host}:#{request.port}/" 
  		#uri = request.url.delete(base)
  		logger.warn("====== Time: #{Time.now},IP: #{request.remote_ip}--URI:#{request.url}--")
  	end

end