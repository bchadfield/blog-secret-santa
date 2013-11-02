class Content < ActiveRecord::Base
	belongs_to :draw
	belongs_to :user
end
