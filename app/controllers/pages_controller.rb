class PagesController < ApplicationController
	skip_before_action :authenticate_user!
	
	def about
		@pool = Pool.first
	end
end
