class CountdownPresenter < SimpleDelegator
  def initialize(group, view)
    super(view)
    @group = group
  end

  def render_countdown
  	content_tag(:p, until_text, id: "until-text") << render_counter
  end

  private

  	def render_counter
      case @group.status
  		when "open", "matched"
  			content_tag(:div, nil, id: "countdown", data: { until: "#{@group.draw_time.strftime('%Y/%m/%d %H:%M %Z')}" })
  		when "closed"
  			content_tag(:div, "We're all done. Sign up now for next time.", id: "countdown")
      when "gifted"
        content_tag(:div, "Santa has delivered the gifts. #{Content.published.count} of #{Match.count} gifts have been published.", id: "countdown")
      when "retired"
        content_tag(:div, "This group is no longer active. You can choose another group in your profile.", id: "countdown")
  		else
  			content_tag(:div, "Drawing now...", id: "countdown")
  		end
  	end

  	def until_text
  		case @group.status
  		when "open"
  			raw "Secret Santa matches are drawn in&nbsp;"
  		when "matched"
  			raw "Gifts are given in&nbsp;"
  		end
  	end
end