class Santa::UsersController < Santa::SantaController
	before_action :find_user_by_token, only: [:show, :edit, :update]
	before_action :find_pool_by_token, only: [:assign, :set_assignments]

	def index
		@users = User.includes(:pool)
	end

	def show
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		if @user.save
			flash[:success] = "#{@user.name} has been created."
			redirect_to edit_user_path(@user)
		else
			flash_errors(@user, true)
			puts flash.inspect
			render :new
		end
	end

	def edit
	end

	def update
		if @user.update(user_params)
			flash[:success] = "Those updates have been saved"
			redirect_to edit_user_path(@user)
		else
			flash_errors(@user, true)
			puts flash.inspect
			render :edit
		end
	end

	def assign
		if params[:search]
			@users = User.includes(:pool).where("name like :search or email like :search", search: "%#{params[:search]}%")
		end
	end

	def set_assignments
		@user = User.find_by(email: params[:email])
		if @user
			if @user.update(role: User.roles[:elf], pool: @pool)
				flash[:success] = "#{@user.name} has been elfed"
				UserMailer.made_elf(@user, @pool).deliver
				redirect_to assign_pool_users_path(@pool)
			else
				flash_errors(@user, true)
				render :assign
			end
		else
			flash[:success] = "An invite email has been sent to #{params[:email]}"
			UserMailer.invited_elf(params[:email], @pool).deliver
			redirect_to assign_pool_users_path(@pool)
		end
	end

	private

		def find_user_by_token
			@user = User.find_by(token: params[:id])
		end

		def find_pool_by_token
			@pool = Pool.find_by(token: params[:pool_id])
		end

		def user_params
			params.require(:user).permit(:name, :subdomain)
		end
end