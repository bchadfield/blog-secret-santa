class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  set_current_tenant_by_subdomain(:pool, :subdomain)
  
  before_action :authenticate, :authorize, :check_profile

  private

  	def check_profile
  		incomplete_profile_redirect if current_user && current_user.incomplete_profile?
  	end

    def incomplete_profile_redirect
      flash[:notice] = "Please complete your profile before you continue."
      redirect_to edit_user_path(current_user)
    end
end
