class Content < ActiveRecord::Base
	belongs_to :draw
	belongs_to :user

	scope :published, -> { where("url is not null").order("updated_at desc") }
end
