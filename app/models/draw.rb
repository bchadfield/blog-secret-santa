class Draw < ActiveRecord::Base
	has_many :matches
	has_many :content

	scope :drawing, -> { where("status != 'closed'") }

	def self.check_if_time_for_draw
		draw = Draw.drawing.first
		if draw
			if draw.open? && draw.draw_time.past?
				draw.match_secret_santas
			elsif draw.matched? && draw.draw_time.past?
				draw.give_gifts
			end
		end
	end

	def open?
		status == "open"
	end

	def matched?
		status == "matched"
	end

	def closed?
		status == "closed"
	end

	def year
		gift_time.strftime("%Y")
	end

	def match_secret_santas
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
				UserMailer.match_notification(giver, receiver).deliver
	    end
	    self.update(status: "matched")
	  else
	  	print "Not enough available users for a draw. Need at least 3."
	  end
	end

	def give_gifts
		matches = Match.where(draw_id: self.id)
		matches.each do |match|
			receiver = User.find_by(id: match.receiver_id)
			content = Content.find_by(user_id: match.giver_id, draw_id: self.id, status: nil)
			if receiver && content && content.body
				content.update(user_id: receiver.id, status: "given")
				UserMailer.send_gift(receiver, content, self).deliver
			end
		end
		self.update(status: "closed")
	end

	def draw_time
		case status
		when "open"
			match_time
		when "matched"
			gift_time
		else
			Time.new(0)
		end
	end
end
