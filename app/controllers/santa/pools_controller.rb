class Santa::PoolsController < Santa::SantaController
	before_action :find_pool_by_token, only: [:show, :edit, :update]

	def index
		@pools = Pool.includes(:users)
	end

	def show
	end

	def new
		@pool = Pool.new
	end

	def create
		@pool = Pool.new(pool_params)
		if @pool.save
			flash[:success] = "#{@pool.name} has been created."
			redirect_to edit_pool_path(@pool)
		else
			flash_errors(@pool, true)
			puts flash.inspect
			render :new
		end
	end

	def edit
	end

	def update
		if @pool.update(pool_params)
			flash[:success] = "Those updates have been saved"
			redirect_to edit_pool_path(@pool)
		else
			flash_errors(@pool, true)
			puts flash.inspect
			render :edit
		end
	end

	private

		def find_pool_by_token
			@pool = Pool.find_by(token: params[:id])
		end

		def pool_params
			params.require(:pool).permit(:name, :subdomain)
		end
end