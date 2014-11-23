class Users::RegistrationsController < Devise::RegistrationsController
	before_filter :configure_permitted_parameters

  def new
    build_resource({})
    resource.group = Group.find_by(slug: params[:group_id])
    respond_with self.resource
  end

  protected

  	def configure_permitted_parameters
	    devise_parameter_sanitizer.for(:sign_up) do |u|
	      u.permit(:email, :password, :password_confirmation, :group_id)
	    end
	  end
end
