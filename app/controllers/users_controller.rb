class UsersController < ApplicationController
  def index
  end

  def show
  end

  def edit
  end

  def update
  	@user = User.find(params[:id])
  	if @user.update_attributes(user_params)
  		redirect_to root_path
  	else
  		render "sessions/create"
  	end
  end

  private

  	def user_params
  		params.require(:user).permit(:name, :email)
  	end
end
