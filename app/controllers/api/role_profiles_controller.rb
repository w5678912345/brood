class Api::RoleProfilesController < Api::BaseController
  CODES = Api::CODES

  before_filter :require_computer_by_ckey
  def show
    @role_profile = RoleProfile.find_by_name(params[:name])
  end

  private
  def require_computer_by_ckey
    @computer = Computer.find_by_auth_key(params[:ckey]) if params[:ckey]
    @code = CODES[:not_find_computer] unless @computer
    return render :partial => 'api/result' unless @code == 0  
  end
end