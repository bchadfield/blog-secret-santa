namespace :draw do
	desc "Draw secret santas"
	task :secret_santas => :environment do
		Draw.open.first.draw_secret_santas
	end
end