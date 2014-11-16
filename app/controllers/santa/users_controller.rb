class Santa::UsersController < Santa::SantaController
	before_action :find_user_by_token, only: [:show, :edit, :update]
	before_action :find_group_by_token, only: [:assign, :set_assignments]

	def index
		@users = User.includes(:group)
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
			@users = User.includes(:group).where("name like :search or email like :search", search: "%#{params[:search]}%")
		end
	end

	def set_assignments
		@user = User.find_by(email: params[:email])
		if @user
			if @user.update(role: User.roles[:elf], group: @group)
				flash[:success] = "#{@user.name} has been elfed"
				UserMailer.made_elf(@user, @group).deliver
				redirect_to assign_group_users_path(@group)
			else
				flash_errors(@user, true)
				render :assign
			end
		else
			flash[:success] = "An invite email has been sent to #{params[:email]}"
			UserMailer.invited_elf(params[:email], @group).deliver
			redirect_to assign_group_users_path(@group)
		end
	end

	private

		def find_user_by_token
			@user = User.find_by(token: params[:id])
		end

		def find_group_by_token
			@group = Group.find_by(token: params[:group_id])
		end

		def user_params
			params.require(:user).permit(:name, :subdomain)
		end
end