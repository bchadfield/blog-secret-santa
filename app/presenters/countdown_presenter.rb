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
  			content_tag(:div, nil, id: "countdown", data: { until: "#{@draw.draw_time}" })
  		else
  			if @draw.status == "closed"
  				content_tag(:div, "Sign up now for the next draw", id: "countdown")
  			else
  				content_tag(:div, "Drawing now...", id: "countdown")
  			end
  		end
  	end

  	def until_text
  		case @draw.status
  		when "open"
  			"Until secret santas matches are drawn."
  		when "matched"
  			"Until blog gifts are given."
  		end
  	end
end