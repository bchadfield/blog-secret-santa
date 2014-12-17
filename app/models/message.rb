class Message
	include ActiveModel::Model
	attr_accessor :to, :subject, :body, :template

	def initialize(attributes={})
    super
    @template ||= "blank"
  end

	def deliver
    @body = Kramdown::Document.new(@body).to_html unless @body.blank?
		if User.valid_scope?(@to)
      if @to = "playing"
        users = User.unscoped.available.joins("INNER JOIN matches ON matches.giver_id = users.id")
      else
        users = User.unscoped.send(@to)
      end
      users.each do |user|
        puts user.name
      	MessageMailer.send(@template, user.email, @subject, @body).deliver
      end
    elsif @to.include?(',')
    	@to.gsub(/\s+/, "").split(',').uniq.each do |email|
    		MessageMailer.send(@template, email, @subject, @body).deliver
    	end
    else
    	user = User.find_by(email: @to)
    	MessageMailer.send(@template, user.email, @subject, @body).deliver if user
    end
    self
  rescue Exception => e
    self.errors[:base] << "Error while sending: #{e}"
    self
	end
end