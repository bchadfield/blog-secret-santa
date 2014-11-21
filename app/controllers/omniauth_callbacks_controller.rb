class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Devise::Controllers::Rememberable

  def all
    @user = User.from_omniauth(request.env["omniauth.auth"], request.env['omniauth.params'])

    if @user.persisted?
      remember_me(@user)
      sign_in_and_redirect @user
    else
      session["devise.user_data"] = request.env["omniauth.auth"]
      redirect_to signup_url
    end
  end
  
  alias_method :twitter, :all
  alias_method :facebook, :all
end