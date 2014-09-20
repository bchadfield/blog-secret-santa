module SessionsHelper
  def current_user=(user) 
    @current_user = user
  end
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def signed_in?
    !current_user.nil? 
  end

  def correct_pool?
    current_tenant ? current_user.pool_id == current_tenant.id : true
  end
  
  def authenticate 
    unless signed_in?
      store_location
      redirect_to root_url(subdomain: false), notice: "You'll have to log in to see that page"
    end
  end

  def authorize
    unless correct_pool?
      redirect_to root_url(subdomain: false), notice: "You only have access to the pool you signed up for"
    end
  end
  
  def current_user?(user)
    user == current_user
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default ) 
    clear_return_to
  end
  
  private
    def store_location
      session[:return_to] = request.fullpath
    end
    
    def clear_return_to 
      session[:return_to] = nil
    end
end