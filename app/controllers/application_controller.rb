# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!

	rescue_from CanCan::AccessDenied do |exception|
    redirect_to  request.referer || "/", :alert => exception.message
  end
end
