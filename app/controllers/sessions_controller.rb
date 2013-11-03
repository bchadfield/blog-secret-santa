class SessionsController < ApplicationController
	skip_before_action :authenticate, only: [:new, :create]
	def new

	end

	def create
	  auth = request.env["omniauth.auth"]
	  @user = User.find_by(provider: auth["provider"], uid: auth["uid"]) || User.create_with_omniauth(auth)
	  session[:user_id] = @user.id
	  if @user.email
	  	redirect_to root_path
	  end
	end

	def destroy
	  session[:user_id] = nil
	  redirect_to root_path, notice: "Logged out!"
	end
end