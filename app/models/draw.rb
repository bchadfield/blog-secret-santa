class Draw < ActiveRecord::Base
	has_many :matches
	has_many :content

	scope :open, -> { where(status: "open") }

	def self.check_if_time_for_draw
		draw = self.open.first
		if draw && !draw.draw_time.future?
			draw.draw_secret_santas
		end

	end

	def draw_secret_santas
		user_ids = User.available.map(&:id)
		if user_ids.length > 2
			matches = loop do
	      shuffled = user_ids.shuffle.zip(user_ids.shuffle)
	      break shuffled if shuffled.index { |x,y| x == y } == nil
	    end
	    matches.each do |match|
	    	giver = User.find(match[0])
	    	receiver = User.find(match[1])
	    	Match.create(draw_id: self.id, giver_id: giver.id, receiver_id: receiver.id)
	    	logger.debug UserMailer.match_notification(giver, receiver).deliver
	    	logger.debug "Giver: #{giver.name}, receiver: #{receiver.name}"
	    end
	    self.update(status: "matched")
	  else
	  	print "Not enough available users for a draw. Need at least 3."
	  end
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
