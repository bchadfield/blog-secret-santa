class UserMailer < ActionMailer::Base
  layout "email"
  default from: "\"Blog Secret Santa\" <santa@blogsecretsanta.com>"

  def signup_info(user)
    @user = user
    @subject = "Thanks for joining Blog Secret Santa"
    mail to: @user.email, subject: @subject
  end

  def match_notification(giver, receiver)
    @giver = giver
    @receiver = receiver
    @subject = "Blog Secret Santa draw: Here's who'll receive your gift post" 
    mail to: @giver.email, subject: @subject
  end
  
  def send_gift(user, content, draw)
    @user = user
    @content = content
    @pool = draw
    @subject = "Your Blog Secret Santa gift"
    mail to: @user.email, subject: @subject
  end

  def countdown_alert(user, view, subject)
    @user = user
    @subject = subject
    mail(to: @user.email, subject: @subject) do |format|
      format.text { render view }
      format.html { render view }
    end
  end

  def no_gift_for_you(user)
    @user = user
    @subject = "You're the blameless victim of a naughty child's actions"
    mail to: @user.email, subject: @subject
  end

  def no_gift_from_you(user, receiver)
    @user = user
    @receiver = receiver
    @subject = "We haven't received a gift blog post from you yet"
    mail to: @user.email, subject: @subject
  end

  def made_elf(user, pool)
    @user = user
    @pool = pool
    mail to: @user.email, subject: "You're now an elf for the #{@pool.name} Blog Secret Santa pool"
  end

  def invited_elf(email, pool)
    @pool = pool
    mail to: email, subject: "You're invited to be an elf for the #{@pool.name} Blog Secret Santa pool"
  end
end
