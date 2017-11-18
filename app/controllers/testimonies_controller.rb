class TestimoniesController < ApplicationController
  def index
    @testimonies=Testimony.all
    token_data=TwitterApi.generate_request_token()
    data=TwitterApi.get_access_token(params[:oauth_token],params[:oauth_verifier],token_data['oauth_token_secret'])
    @user_screen_name=data['screen_name']
    Rails.logger.info(data)
    # user = TwitterUser.find_by(email: (data['screen_name']).to_s+'@gmail.com')
    # if user && user.authenticate('testing')
    #   log_in user
    #   redirect_to index_path
    # else
    password=SecureRandom.urlsafe_base64.to_s
    @user = TwitterUser.new(name: data['screen_name'], email: (data['screen_name']).to_s+'@gmail.com', password: password , password_confirmation: password, login_status: '1'.to_i)
    Rails.logger.info(@user)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Twitter App!"
      redirect_to index_path
    else
      Rails.logger.info("Not authenticated")
    end
  end
# end
  def search
    @testimonies=Testimony.all
    @session=request.session_options[:id]
    if !(params[:q].present?)
      flash[:notice] = 'Insert a search key'
      redirect_to search_path
    else
      result_tweet=TwitterApi.generate_access_token()
      if result_tweet.present?
        TwitterApi.search_tweets(result_tweet,params[:q],request.session_options[:id])
      else
        Rails.logger.info("Not Authenticated")
      end
    end

  end
  def  destroy
    @testimonies=Testimony.all
    @testimonies.delete_all
    redirect_to root_path
  end

end
