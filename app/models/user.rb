class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :omniauthable

  # include DeviseOverrideable
	include Tokenfindable
	include Tenantable

	scope :available, -> { where(available: true).where.not(email: nil, blog: nil, name: nil) }
	scope :unavailable, -> { where("available != true OR email IS NULL OR blog IS NULL OR name IS NULL") }
	scope :playing, -> { available.joins(:receiver_match) }
	scope :waiting_list, -> { available.joins("LEFT OUTER JOIN matches ON users.id = matches.receiver_id OR users.id = matches.giver_id").where("matches.receiver_id IS NULL OR matches.giver_id IS NULL") }

	before_create :set_defaults

	has_one :giver_match, class_name: "Match", foreign_key: "receiver_id"
	has_one :giver, through: :giver_match, class_name: "User"
	has_one :receiver_match, class_name: "Match", foreign_key: "giver_id"
	has_one :receiver, through: :receiver_match, class_name: "User"

	validates :name, presence: true, on: :update
	validates :blog, presence: true, on: :update
	validates :group_id, presence: true, on: :update
	validates :email, presence: true, on: :update

	enum role: { blogger: 0, elf: 1, santa: 2 }

	def blog=(value)
		unless value.index(/https?:\/\//)
			value = "http://#{value}"
		end

		write_attribute(:blog, value)
	end

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

	def self.valid_scope?(scope)
		["available", "unavailable", "playing", "waiting_list"].include?(scope)
	end

	def self.statuses(group_status)
		if group_status == "open"
			%w(available unavailable)
		elsif group_status == "matched"
			%w(playing waiting_list unavailable)
		end
	end

	def available?
		available && !incomplete_profile?
	end

	def playing?
		giver_match && available?
	end

	def waiting?
		!giver_match && available?
	end

	def playing_status(group_status)
		if group_status == "open"
			if available?
				"available"
			elsif incomplete_profile?
				"incomplete"
			elsif !available?
				"unavailable"
			end
		elsif group_status == "matched"
			if playing?
				"playing"
			elsif waiting?
				"waiting"
			elsif incomplete_profile?
				"incomplete"
			elsif !available?
				"unavailable"
			end
		end
	end

	def first_name
    name.split(' ')[0]
  end

  def incomplete_profile?
  	!(email && blog && name && group_id)
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
