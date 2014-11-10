class Pool < ActiveRecord::Base
	include Tokenfindable

	has_many :matches
	has_many :content
	has_many :users

	enum status: { open: 0, matched: 1, gifted: 2, closed: 3, retired: 4 }

	MATCH_TIME = Time.utc(Time.now.year, 11, 10)
	GIFT_TIME = Time.utc(Time.now.year, 12, 25)

	validates :name, presence: true
	validates :subdomain, presence: true, format: { with: /\A[a-zA-Z\-]+\z/, message: "can only have letters and -" }

	def self.current_id=(id)
    Thread.current[:pool_id] = id
  end
  
  def self.current_id
    Thread.current[:pool_id]
  end

	def year
		gift_time.strftime("%Y")
	end

	def self.create_matches
		open.each do |pool|
			users = User.available.where(pool: pool)
			if users.length > 2
				matches = loop do
		      shuffled = users.shuffle.zip(users.shuffle)
		      break shuffled if shuffled.index { |x,y| x == y } == nil
		    end
		    matches.each do |match|
		    	giver = match[0]
		    	receiver = match[1]
		    	Match.create(pool: pool, giver: giver, receiver: receiver)
					UserMailer.match_notification(giver, receiver).deliver
		    end
		    pool.matched!
		  else
		  	print "Not enough available users in the #{pool.name} pool. Need at least 3."
		  end
	 	end
	end

	def self.give_gifts
		matches = Match.where(pool_id: self.id)
		matches.each do |match|
			receiver = User.find_by(id: match.receiver_id)
			giver = User.find_by(id: match.giver_id)
			content = Content.find_by(user_id: match.giver_id, pool_id: self.id, status: nil)
			if receiver && content && content.body
				content.update(user_id: receiver.id, status: "given")
				UserMailer.send_gift(receiver, content, self).deliver
			elsif receiver && giver
				UserMailer.no_gift_from_you(giver, receiver).deliver
				UserMailer.no_gift_for_you(receiver).deliver
			end
		end
		self.gifted!
	end

	def draw_time
		if open?
			Pool::MATCH_TIME
		elsif matched?
			Pool::GIFT_TIME
		end
	end
end
