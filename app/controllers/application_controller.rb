class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  before_action :authenticate, :check_for_email

  private

  	def check_for_email
  		if signed_in? && current_user.email.blank?
  			redirect_to email_user_path(current_user)
  		end
  	end
end
