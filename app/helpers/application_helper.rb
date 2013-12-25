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
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=48&d=monsterid"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def host_only(url)
    uri = URI(url)
    uri.host
  end

  def prepare_snippet(body)
    stripped_body = strip_tags(body)
    truncate(stripped_body.sub(/This post is part of a creative.*Currently anonymous guest blogger/, ''), length: 150, separator: ' ')
  end
end