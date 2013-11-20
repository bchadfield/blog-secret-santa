class PagesController < ApplicationController
	skip_before_action :authenticate, only: :about  
end
