class User < ActiveRecord::Base
	include Tokenfindable
	acts_as_tenant(:pool)

	scope :available, -> { where(available: true).where.not(email: nil) }

	has_one :giver, class_name: "Match", foreign_key: "giver_id"
	has_one :receiver, class_name: "Match", foreign_key: "receiver_id"
	belongs_to :pool

	before_create :set_defaults

	validates :name, presence: true
	validates :url, presence: true
	validates :email, presence: true, on: :update

	enum role: { blogger: 0, admin: 1, super_admin: 2 }

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

	def available?
		available
	end

	def first_name
    name.split(' ')[0]
  end

  private

  	def set_defaults
  		self.available = true
  		self.role = User.roles[:blogger]
  	end
end
