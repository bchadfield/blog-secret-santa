class Elves::UserController < Elves::ElvesController

	def index
		@users = User.includes(:matches).load
	end

	def show
		@user = User.includes(:matches, :content).find_by(token: params[:id])
	end

	def edit
  	@user = User.find_by(token: params[:id])
  end

  def update
  	@user = User.find_by(token: params[:id])
  	respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, flash: { success: "That update has been saved successfully" }}
        format.js { render js: "window.location = '#{admin_account_path(@account)}'" }
      else
        format.html { 
          flash_errors(@account)
          render 'new'
        }
        format.js
      end
    end
  end

  private

  	def user_params
      params.require(:user).permit(:name, :email, :blog, :location)
    end
end