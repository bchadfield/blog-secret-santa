class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :omniauthable

  # include DeviseOverrideable
	include Tokenfindable
	include Tenantable

	scope :available, -> { where(available: true).where.not(email: nil) }
	scope :waiting_list, -> { available.joins("LEFT JOIN matches ON users.id = matches.receiver_id OR users.id = matches.giver_id").where("matches.receiver_id IS NULL OR matches.giver_id IS NULL") }

	before_create :set_defaults

	has_one :giver_match, class_name: "Match", foreign_key: "receiver_id"
	has_one :giver, through: :giver_match, class_name: "User"
	has_one :receiver_match, class_name: "Match", foreign_key: "giver_id"
	has_one :receiver, through: :receiver_match, class_name: "User"

	validates :name, presence: true, on: :update
	validates :blog, presence: true, on: :update
	validates :pool_id, presence: true, on: :update
	validates :email, presence: true, on: :update

	enum role: { blogger: 0, elf: 1, santa: 2 }

	def self.from_omniauth(auth)
	  unscoped.where(provider: auth["provider"], uid: auth["uid"]).first_or_create do |user|
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
		available && !incomplete_profile?
	end

	def playing?
		giver_match && receiver_match && available?
	end

	def first_name
    name.split(' ')[0]
  end

  def incomplete_profile?
  	!(email && blog && name && pool_id)
  end

  # def giver
  # 	User.find_by(id: Match.find_by(receiver_id: self.id))
  # end

  # def receiver
  # 	User.find_by(id: Match.find_by(giver_id: self.id))
  # end

  private

  	def set_defaults
  		self.available = true
  		self.role = User.roles[:blogger] if self.role.nil?
  	end
end
