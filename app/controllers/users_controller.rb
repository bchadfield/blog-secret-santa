class UsersController < ApplicationController
  skip_before_action :check_profile, only: [:edit, :update]
  before_action :find_user, only: [:show, :edit, :update, :email, :set_email, :destroy]
  before_action :authorize, only: [:edit, :update, :email, :set_email, :destroy]

  def index
    @users = User.available.order(created_at: :asc)
  end

  def show
  end

  def edit
  end

  def update
    was_incomplete = @user.incomplete_profile?
  	if @user.update_attributes(user_params)
      if was_incomplete
        flash[:success] = "Great! Your profile is complete and you're ready for Blog Secret Santa"
        UserMailer.welcome(@user).deliver
        redirect_to root_url(subdomain: @user.group.subdomain)
      else
        flash[:success] = "Updated without a hitch!"
  		  redirect_to edit_user_url(@user, subdomain: @user.group.subdomain)
      end
  	else
      flash[:error] = @user.errors.full_messages
  		render "edit"
  	end
  end

  def destroy
    session[:user_id] = nil
    @user.destroy
    flash[:success] = "Well, you went removed yourself. Now it's just you against the world."
    redirect_to root_path
  end

  private

  	def user_params
  		params.require(:user).permit(:name, :email, :blog, :available, :group_id, :location)
  	end

    def find_user
      @user = User.find_by(token: params[:id])
    end

    def authorize
      unless @user == current_user
        flash[:error] = "You don't have access."
        redirect_to root_path
      end
    end
end