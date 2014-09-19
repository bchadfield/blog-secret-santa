class PagesController < ApplicationController
	skip_before_action :authenticate

	def about
		@pool = Pool.first
	end
end
