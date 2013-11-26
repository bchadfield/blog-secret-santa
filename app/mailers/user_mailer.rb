class UserMailer < ActionMailer::Base
  default from: "\"Blog Secret Santa\" <secretsanta@csworkflow.com>"

  def signup_info(user)
    @user = user
    @subject = "Thanks for joining Blog Secret Santa"
    mail to: user.email, subject: @subject
  end

  def match_notification(giver, receiver)
    @giver = giver
    @receiver = receiver
    @subject = "Blog Secret Santa draw: Here's who'll receive your gift post" 
    mail to: giver.email, subject: @subject
  end
  
  def send_gift(user, content, draw)
    @user = user
    @content = content
    @draw = draw
    @subject = "Your Blog Secret Santa gift"
    mail to: user.email, subject: @subject
  end
end
