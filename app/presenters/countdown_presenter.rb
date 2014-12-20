class CountdownPresenter < SimpleDelegator
  def initialize(group, view)
    super(view)
    @group = group
  end

  def render_countdown
    if ["open", "matched"].include?(@group.status)
      content_tag(:p, raw("#{until_text}&nbsp;"), id: "until-text") << render_counter
    end
  end

  private

  	def render_counter
      content_tag(:div, nil, id: "countdown", data: { until: "#{@group.draw_time.strftime('%Y/%m/%d %H:%M %Z')}" })
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