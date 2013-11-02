class SecretSanta < ActiveRecord::Base
	belongs_to :draw
	belongs_to :giver, class_name: "User"
	belongs_to :receiver, class_name: "User"
end
