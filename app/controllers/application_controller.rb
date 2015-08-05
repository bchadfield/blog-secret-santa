class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # include SessionsHelper

  around_action :scope_current_tenant  
  before_action :authenticate_user!, :authorize, :check_profile

  def after_sign_in_path_for(user)
    if user.group
      group_path(user.group)
    elsif user.santa?
      santa_root_path
    else
      edit_user_path(user)
    end
  end

  def after_sign_out_path_for(user)
    root_path
  end

  def incomplete_profile_redirect
    flash[:notice] = "Please complete your profile before you continue."
    redirect_to edit_user_path(current_user)
  end

  private
  
    def current_tenant
      @current_tenant ||= Group.find(current_user.group_id) if current_user && current_user.group_id.present?
    end
    helper_method :current_tenant
    
    def scope_current_tenant
      Group.current_id = current_tenant ? current_tenant.id : nil
      yield
    ensure
      Group.current_id = nil
    end

    def authorize
      unless correct_group?
        redirect_to group_path(current_user.group), notice: "You only have access to the group you signed up for"
      end
    end

    def correct_group?
      current_user && current_tenant ? current_user.group_id == current_tenant.id : true
    end

  	def check_profile
  		incomplete_profile_redirect if current_user && current_user.incomplete_profile? && !current_user.santa?
  	end

    def deny_access
      flash[:error] = "You don't have access to see that page"
      redirect_to root_path
    end

    def flash_errors(object, now = false)
      if object.errors.any?
        object.errors.full_messages.each do |message|
          if now
            flash.now[:error] ||= []
            flash.now[:error] << message
          else
            flash[:error] ||= []
            flash[:error] << message
          end
        end
        true
      else
        false
      end
    end
end
