class Santa::PoolsController < Santa::SantaController

	def index
		@pools = Pool.all
	end

	def show
		@pool = Pool.find_by(token: params[:id])
	end
end