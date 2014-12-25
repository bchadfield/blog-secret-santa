class Elves::GroupsController < Elves::ElvesController

	def show
		@group = current_tenant
		if params[:filter] && User.valid_scope?(params[:filter])
			@users = User.send(params[:filter]).includes(:giver, receiver_match: :content).order(:name)
		else
			@users = User.includes(:giver, receiver_match: :content).order(:name)
		end
	end
end