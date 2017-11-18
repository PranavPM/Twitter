class SessionsController < ApplicationController
  def new
    token_data=TwitterApi.generate_request_token()
    auth_token, auth_token_secret = [token_data['oauth_token'], token_data['oauth_token_secret']]
    @login_url = 'https://api.twitter.com/oauth/authorize?oauth_token='+auth_token
  end

  def create
    user = TwitterUser.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to index_path
    else
      flash[:danger] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end
  end
  def current_user
    @current_user ||= TwitterUser.find_by(id: session[:user_id])
  end
  def destroy
    begin
      TwitterUser.find_by(login_status: 1).destroy
      log_out if logged_in?
      redirect_to root_url
    rescue
    log_out if logged_in?
    redirect_to root_url

  end
  end
end
