class Message
	include ActiveModel::Model
	attr_accessor :to, :subject, :body, :template

	def initialize(attributes={})
    super
    @template ||= "blank"
  end

	def deliver
		if to == "all"
			User.available.each do |user|
    		MessageMailer.send(template, user, subject, body).deliver
    	end
    elsif to.include?(',')
    	to.gsub(/\s+/, "").split(',').uniq.each do |email|
    		MessageMailer.send(template, email, subject, body).deliver
    	end
    else
    	user = User.find_by(email: email)
    	MessageMailer.send(template, user, subject, body).deliver if user
    end
    self
  rescue Exception => e
    self.errors[:base] << "Error while sending: #{e}"
	end
end