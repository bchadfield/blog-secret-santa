class Santa::SantaController < ApplicationController
	# layout 'santa'

	skip_before_action :authorize, :check_profile
	before_action :authorize_santa

	private 

		def authorize_santa
			deny_access unless current_user.santa?
		end

end