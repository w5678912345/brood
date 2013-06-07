# encoding: utf-8
# @suxu
# 
class ApiController < ActionController::Base
  
  layout :nil
  before_filter :require_api
  after_filter  :get_msg
  #
  CODES = Api::CODES

  def reg
    #test params
    params[:user_id] = User.first.id
  	#-------------------
    user = User.find_by_id(params[:user_id])
    return @code = CODES[:not_find_user] unless user #not find user
    @computer = Computer.new(:hostname=>params[:hostname],:auth_key => params[:auth_key],:user_id=>user.id)
    return @code = CODES[:not_valid_computer] unless @computer.valid? #computer validate not pass
    begin
      @code = 1 if @computer.save
     rescue Exception => ex
      @code = -1
    end
  end

 
  def online
    # test params
    params[:ip] = params[:ip] || request.remote_ip
    params[:computer_id] = @current_computer.id
    #-----------------
    if params[:rid]
      @role = Role.where(:online => false).find_by_id(params[:rid])
    else
      @role = Role.where(:online => false).first
    end
    return @code = CODES[:not_find_role] unless @role # not find role
    return @code = CODEs[:role_have_online] if @role.online # role does online
    #call
    begin
      @code = @role.api_online params
    rescue Exception => ex
      @code = -1
    end
  end

 
  def sync
    #----------------
    @role = Role.find_by_id(params[:role_id] || params[:rid])
    return @code = CODES[:not_find_role] unless @role # not find role
    return @code = CODES[:role_not_online] unless @role.online # role does not online 
    #call
    begin
       @code = @role.api_sync params 
    rescue Exception => ex
       @code = -1
    end
  end


  def offline
    @role = Role.find_by_id(params[:role_id] || params[:rid])
    return @code = CODES[:not_find_role] unless @role # not find role
    return @code = CODES[:role_not_online] unless @role.online # role does not online 
    #call 
    begin
       @code = @role.api_offline params
    rescue Exception => ex
       @code = -1
    end
  end

  def roles
    @roles = Role.where(:online => false).limit(params[:limit].to_i || 10).offset(params[:offset] || 0)
  end

  #api doc
  def readme
    render :layout => 'application'
  end


  #
  private 
  def require_api
      @code = 0
      @current_computer = Computer.find_by_auth_key(params[:ckey] || "computer1")

  end

  def get_msg
    
  end

end