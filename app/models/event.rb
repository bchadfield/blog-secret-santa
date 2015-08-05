class Event < ActiveRecord::Base
	enum status: { open: 0, matched: 1, gifted: 2, closed: 3, retired: 4 }

	MATCH_TIME = Time.utc(Time.now.year, 12, 05)
	GIFT_TIME = Time.utc(Time.now.year, 12, 25)

	validates :name, presence: true
	validates :slug, presence: true, format: { with: /\A[a-zA-Z\-]+\z/, message: "can only have letters and -" }
	validates :status, presence: true
end
