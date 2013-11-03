class User < ActiveRecord::Base
	has_many :giving_matches, class_name: "Match", foreign_key: "giver_id"
	has_many :receiving_matches, class_name: "Match", foreign_key: "receiver_id"
	has_many :content

	scope :available, -> { where(available: true) }

	before_create :set_availability

	def self.create_with_omniauth(auth)
	  create! do |user|
	    user.provider = auth["provider"]
	    user.uid = auth["uid"]
	    user.name = auth["info"]["name"]
	    user.image = auth["info"]["image"]
	  end
	end

	def admin?
		admin
	end

	def available?
		available
	end

	def first_name
    name.split(' ')[0]
  end

  private

  	def set_availability
  		self.available = true
  	end
end
