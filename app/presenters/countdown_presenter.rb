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
  		if @group.draw_time.future?
  			content_tag(:div, nil, id: "countdown", data: { until: "#{@group.draw_time.strftime('%Y/%m/%d %H:%M %Z')}" })
  		else
  			if @group.status == "closed"
  				content_tag(:div, "We're all done. Sign up now for next time.", id: "countdown")
  			else
  				content_tag(:div, "Drawing now...", id: "countdown")
  			end
  		end
  	end

  	def until_text
  		case @group.status
  		when "open"
  			"Secret Santa matches are drawn in"
  		when "matched"
  			"Gifts are given in"
  		end
  	end
end