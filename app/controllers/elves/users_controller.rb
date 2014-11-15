class Elves::UsersController < Elves::ElvesController
  before_action :find_user_by_token, only: [:show, :edit, :update, :pull_out, :remove, :replace]

	def show
	end

	def edit
  end

  def update
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

  def pull_out
  end

  def remove
    @user.giver.receiver = @user.receiver
    @user.receiver_match.delete
    @user.update(available: false)
    flash[:success] = "#{@user.name} has been removed from this year's secret santa"
    redirect_to elves_path
  end

  def replace
    @replacement = User.find_by(token: params[:replacement])
    @user.giver.receiver = @user.receiver.giver = @replacement
    @user.update(available: false)
    flash[:success] = "#{@user.name} has been replaced by #{@replacement.name} for this year's secret santa"
    redirect_to elves_path
  end

  private

    def find_user_by_token
      @user = User.find_by(token: params[:id])
    end

  	def user_params
      params.require(:user).permit(:name, :email, :blog, :location)
    end
end