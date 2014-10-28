class Elves::PoolsController < Elves::ElvesController

	def show
		@pool = current_tenant
	end
end