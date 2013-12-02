class PagesController < ApplicationController
	skip_before_action :authenticate, only: :about  

	def about
		@draw = Draw.first
	end
end
