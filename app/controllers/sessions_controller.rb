
class SessionsController < ApplicationController
  before_action :direct_to_cat_index, only: [:new] 

  def new
  end

  def create
    # fail
    @user = User.find_by_credentials(
    params[:user][:user_name],
    params[:user][:password]
    )

    if @user.nil?
      render :new
    else
      log_in!
    end
  end

  def destroy
    log_out!
  end

  private

  def direct_to_cat_index
    redirect_to cats_url if current_user
  end
end
