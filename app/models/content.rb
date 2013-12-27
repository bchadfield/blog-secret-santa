class Content < ActiveRecord::Base
	belongs_to :draw
	belongs_to :user

	scope :published, -> { where("url is not null and status = 'given'").order("updated_at desc") }

	validates :url, format: { with: /\A(http|https):\/\/.+/, message: "must start with http:// or https://" }, allow_nil: true

	def given?
		status == "given"
	end
end