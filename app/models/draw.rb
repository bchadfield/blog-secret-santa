class Draw < ActiveRecord::Base
	has_many :matches
	has_many :content

	scope :open, -> { where(status: "open") }

	def draw_secret_santas
		user_ids = User.available.map(&:id)
		if user_ids.length > 2
			matches = loop do
	      shuffled = user_ids.shuffle.zip(user_ids.shuffle)
	      break shuffled if shuffled.index { |x,y| x == y } == nil
	    end
	    matches.each do |match|
	    	Match.create(draw_id: self.id, giver_id: match[0], receiver_id: match[1])
	    end
	  else
	  	print "Not enough available users for a draw. Need at least 3."
	  end
	end

	def in_the_future?
		match_time.future? || gift_time.future?
	end

	def draw_time
		case status
		when "open"
			match_time
		when "matched"
			gift_time
		end
	end
end
