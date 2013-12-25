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

  	def find_draw
      params_id = (params[:controller] == "draw" && params[:id]) || params[:draw_id]
      puts params_id
  		@draw = params_id ? Draw.find_by(gift_time: Time.new(params_id).all_year) : Draw.first
  	end
end
