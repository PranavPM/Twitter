class TwitterUsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  def destroy
    TwitterUser.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end


  def index
    @users = TwitterUser.all
  end
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  def show
    @user = TwitterUser.find(params[:id])
  end

  def new
    @user = TwitterUser.new
  end

  def create
    @user = TwitterUser.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Twitter App!"
      redirect_to index_path
    else
      render 'new'
    end
  end

  def edit
    @user = TwitterUser.find(params[:id])
  end
  def update
    @user = TwitterUser.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end


  private

  def user_params
    params.require(:twitter_user).permit(:name, :email, :password,
      :password_confirmation)
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    def correct_user
      @user = TwitterUser.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

  end
