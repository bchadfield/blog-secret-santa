class Elves::ElvesController < ApplicationController
	# layout 'elves'
	
	before_action :authorize_elf

	private 

		def authorize_elf
			deny_access unless current_user.elf? || current_user.santa?
		end

end