class GroupMailer < ActionMailer::Base
  default from: "\"Blog Secret Santa\" <santa@blogsecretsanta.com>"

  def enquiry(group, email)
    @group = group
    @email = email
    mail from: @email, to: "\"Blog Secret Santa\" <santa@blogsecretsanta.com>", subject: "I want to start a #{group} group"
  end
end
