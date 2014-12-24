module ApplicationHelper
  require 'uri'
  
  # Return a title on a per-page basis. 
  def title(page_title)
    base_title = "Blog Secret Santa" 
    content_for(:title) { "#{page_title} | #{base_title}" }
    content_for(:heading) { page_title }
  end 

  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user)
    if user.email
      gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
      gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=48&d=mm"
    else
      gravatar_url = "https://secure.gravatar.com/avatar/0000000000?s=48&d=mm"
    end
    image_tag(gravatar_url, alt: user.name, class: "csw-avatar")
  end

  def host_only(url)
    uri = URI(url)
    uri.host
  rescue URI::InvalidURIError
    ''
  end

  def prepare_snippet(body)
    stripped_body = strip_tags(body)
    truncate(stripped_body.sub(/This post was anonymously.*Santa's list of 2013 gift posts\./, ''), length: 150, separator: ' ')
  end

  def group_title(group)
    case group.status
    when "gifted"
      "Gifts are ready for the #{@group.name} group"
    else
      "Welcome to the #{@group.name} group"
    end
  end
end