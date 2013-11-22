class User < ActiveRecord::Base
	has_many :giving_matches, class_name: "Match", foreign_key: "giver_id"
	has_many :receiving_matches, class_name: "Match", foreign_key: "receiver_id"
	has_many :content

	scope :available, -> { where("available = ? AND email IS NOT NULL", true) }

	before_create :set_availability

	validates :name, presence: true
	validates :url, presence: true
	validates :email, presence: true, on: :update


	def self.create_with_omniauth(auth)
	  create! do |user|
	    user.provider = auth["provider"]
	    user.uid = auth["uid"]
	    user.name = auth["info"]["name"]
	    user.image = auth["info"]["image"]
	    user.location = auth["info"]["location"]
	    user.url = auth["info"]["urls"]["Website"] ? Unshorten[auth["info"]["urls"]["Website"]] : auth["info"]["urls"]["Twitter"]
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
