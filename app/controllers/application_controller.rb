class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  def current_user
    @current_user ||=TwitterUser.find(session[:user_id]) if session[:user_id]
  rescue ActiveRecord::RecordNotFound
session[:user_id] = nil # or reset_session
end
  helper_method :current_user
end
