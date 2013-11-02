class User < ActiveRecord::Base
	has_many :secret_santas, class_name: "SecretSanta", foreign_key: "giver_id"
	has_many :receiving_secret_santas, class_name: "SecretSanta", foreign_key: "receiver_id"
	has_many :content

	scope :available, -> { where(available: true) }

	def self.create_with_omniauth(auth)
	  create! do |user|
	    user.provider = auth["provider"]
	    user.uid = auth["uid"]
	    user.name = auth["info"]["name"]
	  end
	end

	def admin?
		admin
	end

	def available?
		available
	end
end
