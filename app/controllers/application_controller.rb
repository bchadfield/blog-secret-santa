class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # include SessionsHelper

  set_current_tenant_by_subdomain(:pool, :subdomain)
  
  before_action :authenticate_user!, :authorize, :check_profile

  def after_sign_in_path_for(user)
    if user.pool
      root_url(subdomain: user.pool.subdomain)
    else
      edit_user_path(user)
    end
  end

  def after_sign_out_path_for(user)
    root_url(subdomain: nil)
  end

  private

    def authorize
      unless correct_pool?
        redirect_to root_url(subdomain: false), notice: "You only have access to the pool you signed up for"
      end
    end

    def correct_pool?
      current_user && current_tenant ? current_user.pool_id == current_tenant.id : true
    end

  	def check_profile
  		incomplete_profile_redirect if current_user && current_user.incomplete_profile?
  	end

    def incomplete_profile_redirect
      flash[:notice] = "Please complete your profile before you continue."
      redirect_to edit_user_path(current_user)
    end
end
