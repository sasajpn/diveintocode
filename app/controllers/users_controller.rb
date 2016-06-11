class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end
  
  
  private
  
    def user_params
      params.require(:user).permit(:name, :image, :remove_image)
    end
end
