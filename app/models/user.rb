class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :omniauthable

	include Tokenfindable
	acts_as_tenant(:pool)

	scope :available, -> { where(available: true).where.not(email: nil) }

	has_one :giver, class_name: "Match", foreign_key: "giver_id"
	has_one :receiver, class_name: "Match", foreign_key: "receiver_id"
	belongs_to :pool

	before_create :set_defaults

	validates :name, presence: true, on: :update
	validates :blog, presence: true, on: :update
	validates :email, presence: true, on: :update

	enum role: { blogger: 0, admin: 1, super_admin: 2 }

	def self.from_omniauth(auth)
	  where(provider: auth["provider"], uid: auth["uid"]).first_or_create do |user|
	    user.provider = auth["provider"]
	    user.uid = auth["uid"]
	    user.password = Devise.friendly_token[0,20]
	    user.name = auth["info"]["name"]
	    user.email = auth["info"]["email"]
	    user.image = auth["info"]["image"]
	    user.location = auth["info"]["location"]
	    user.blog = auth["info"]["urls"]["Website"] ? Unshorten[auth["info"]["urls"]["Website"]] : auth["info"]["urls"]["Twitter"]
	  end
	end

	def available?
		available
	end

	def first_name
    name.split(' ')[0]
  end

  def incomplete_profile?
  	!(email && blog)
  end

  private

  	def set_defaults
  		self.available = true
  		self.role = User.roles[:blogger]
  	end
end
