class UsersController < ApplicationController
  before_action :direct_to_cat_index, only: [:new]

  def new

  end

  def create
    @user = User.new(user_params)

    if @user.save
      log_in!
    else
      render :new
    end
  end

  def user_params
    self.params.require(:user).permit(:user_name, :password)
  end

  private

  def direct_to_cat_index
    redirect_to cats_url if current_user
  end
end
