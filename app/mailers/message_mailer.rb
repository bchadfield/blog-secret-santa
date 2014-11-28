class MessageMailer < ActionMailer::Base
	layout "email"
  default from: "\"Blog Secret Santa\" <santa@blogsecretsanta.com>"

  def blank(email, subject, body)
  	@body = body
    mail to: email, subject: subject
  end

  def we_are_back(email, subject, body)
  	mail to: email, subject: "Blog Secret Santa is back! Register now for Christmas #{Time.now.strftime('%Y')}"
  end
end
