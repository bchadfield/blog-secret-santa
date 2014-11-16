class PagesController < ApplicationController
	skip_before_action :authenticate_user!
	
	def about
		@group = Group.first
	end

	def home
		render layout: "home"
	end

end
