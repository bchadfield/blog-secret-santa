class CountdownPresenter < SimpleDelegator
  attr_reader :draw

  def initialize(draw, view)
    super(view)
    @draw = draw
  end

  def render_countdown
  	render_counter << content_tag(:p, until_text, id: "until-text")
  end

  private

  	def render_counter
  		if @draw.draw_time.future?
  			content_tag(:div, nil, id: "countdown", data: { until: "#{@draw.draw_time.strftime('%Y/%m/%d %H:%M %Z')}" })
  		else
  			if @draw.status == "closed"
  				content_tag(:div, "We're all done. Sign up now for next time.", id: "countdown")
  			else
  				content_tag(:div, "Drawing now...", id: "countdown")
  			end
  		end
  	end

  	def until_text
  		case @draw.status
  		when "open"
  			"until Secret Santa matches are drawn."
  		when "matched"
  			"until blog gifts are given."
      when "closed"
        "Read all the #{link_to 'gift blogs', draw_content_index_path(@draw)} for the last draw.".html_safe
  		end
  	end
end