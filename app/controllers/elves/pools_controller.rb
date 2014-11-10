class Elves::PoolsController < Elves::ElvesController

	def show
		@pool = current_tenant
		@users = User.includes(:giver, :receiver)
	end
end