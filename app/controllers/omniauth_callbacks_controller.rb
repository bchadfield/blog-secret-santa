class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Devise::Controllers::Rememberable

  def all
    @authentication = Authentication.with_omniauth(request.env["omniauth.auth"])

    if user_signed_in?
      if @authentication.user == current_user
        # User is signed in so they are trying to link an authentication with their
        # account. But we found the authentication and the user associated with it 
        # is the current user. So the authentication is already associated with 
        # this user. So let's display an error message.
        redirect_to root_url, notice: "Already linked that account!"
      else
        # The authentication is not associated with the current_user so lets 
        # associate the authentication
        @authentication.user = current_user
        @authentication.save
        redirect_to root_url, notice: "Successfully linked that account!"
      end
    else
      if @authentication.user.present?
        # The authentication we found had a user associated with it so let's 
        # just log them in here
        @user = @authentication.user
      else
        # No user associated with the authentication so we need to create a new one
        @user = User.with_omniauth(request.env["omniauth.auth"], request.env['omniauth.params'])
        @authentication.user = @user
        @authentication.save
      end
      remember_me @user
      sign_in_and_redirect @user
    end
  end
  
  alias_method :twitter, :all
  alias_method :facebook, :all
end