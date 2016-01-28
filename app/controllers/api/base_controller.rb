# encoding: utf-8
# @suxu
# 
class Api::BaseController < ActionController::Base
	layout :nil
	CODES = Api::CODES
  LAST_GOLD_AGENT_NAME = "终极代理商711"
	before_filter :print_log,:except=>[:readme]

  def self.LAST_GOLD_AGENT_NAME
    "终极代理商711"
  end
	def readme
    	render :layout => 'application',:template => 'api/readme'
  end


  def doc
    render :layout => 'application',:template => 'api/doc'
  end

  def ping
    render :json=>{:code=>1}
  end

  def hi
    ip = Ip.find_or_create(request.remote_ip)
    render :json =>{:ip=>request.remote_ip,:can_use=>ip.can_use?}
  end

  def is_open
    render :json => {:code=>Setting.is_open}
  end

  	private 
  	def print_log
      params[:ip] = params[:ip] || request.remote_ip
      @code = 0
  		base = "#{request.protocol}#{request.host}:#{request.port}/" 
  		#uri = request.url.delete(base)
  		#logger.warn("====== Time: #{Time.now},IP: #{params[:ip]}--URI:#{request.url}--")
  	end

end