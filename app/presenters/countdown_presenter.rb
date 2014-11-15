class CountdownPresenter < SimpleDelegator
  def initialize(pool, view)
    super(view)
    @pool = pool
  end

  def render_countdown
  	content_tag(:p, until_text, id: "until-text") << render_counter
  end

  private

  	def render_counter
  		if @pool.draw_time.future?
  			content_tag(:div, nil, id: "countdown", data: { until: "#{@pool.draw_time.strftime('%Y/%m/%d %H:%M %Z')}" })
  		else
  			if @pool.status == "closed"
  				content_tag(:div, "We're all done. Sign up now for next time.", id: "countdown")
  			else
  				content_tag(:div, "Drawing now...", id: "countdown")
  			end
  		end
  	end

  	def until_text
  		case @pool.status
  		when "open"
  			"Secret Santa matches are drawn in"
  		when "matched"
  			"Gifts are given in"
      when "closed"
        "Read all the #{link_to 'gift blogs', draw_content_index_path(@pool.year)} for the last draw.".html_safe
  		end
  	end
end