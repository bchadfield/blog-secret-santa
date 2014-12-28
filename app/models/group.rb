class Group < ActiveRecord::Base
	include Tokenfindable

	has_many :matches
	has_many :content
	has_many :users

	enum status: { open: 0, matched: 1, gifted: 2, closed: 3, retired: 4 }

	MATCH_TIME = Time.utc(Time.now.year, 12, 05)
	GIFT_TIME = Time.utc(Time.now.year, 12, 25)

	validates :name, presence: true
	validates :slug, presence: true, format: { with: /\A[a-zA-Z\-]+\z/, message: "can only have letters and -" }
	validates :status, presence: true

	def to_param
		slug
	end

	def self.current_id=(id)
    Thread.current[:group_id] = id
  end
  
  def self.current_id
    Thread.current[:group_id]
  end

	def year
		gift_time.strftime("%Y")
	end

	def self.create_matches
		logger.info "Starting to create matches for all open groups"
		count = 0
		open.each do |group|
			group.create_matches
			count += 1
	 	end
	 	logger.info "Finished creating matches for #{count} groups"
	end

	def create_matches
		logger.info "Starting to create matches for the #{self.name} group"
		users = User.available.where(group: self)
		count = 0
		if users.length > 2
			matches = loop do
	      shuffled = users.shuffle.zip(users.shuffle)
	      break shuffled if shuffled.index { |x,y| x == y } == nil
	    end
	    matches.each do |match|
	    	giver = match[0]
	    	receiver = match[1]
	    	Match.create(group: self, giver: giver, receiver: receiver)
				UserMailer.match_notification(giver, receiver).deliver_later
				count += 1
	    end
	    self.matched!
	  else
	  	print "Not enough available users in the #{group.name} group. Need at least 3."
	  end
	  logger.info "Finished creating #{count} matches the #{self.name} group"
	end

	def self.give_gifts
		logger.info "Starting to deliver gifts for all matched groups"
		count = 0
		Group.matched.each do |group|
			group.give_gifts
			count += 1
		end
		logger.info "Finished delivering gifts for #{count} groups"
	end

	def give_gifts
		logger.info "Starting to deliver gifts for the #{self.name} group"
		matches = Match.includes(:giver, :receiver).where(group_id: self.id)
		sent = 0
		missed = 0
		matches.each do |match|
			content = Content.find_by(match: match)
			if match.receiver && content && content.body
				content.given!
				UserMailer.send_gift(match.receiver, content, self).deliver_later
				sent += 1
			elsif match.receiver && match.giver
				UserMailer.no_gift_from_you(match.giver, match.receiver).deliver_later
				UserMailer.no_gift_for_you(match.receiver).deliver_later
				missed += 1
			end
		end
		self.gifted!
		logger.info "Finished #{sent} delivering gifts with #{missed} missing out for the #{self.name} group"
	end

	def draw_time
		if open?
			Group::MATCH_TIME
		elsif matched?
			Group::GIFT_TIME
		end
	end
end
