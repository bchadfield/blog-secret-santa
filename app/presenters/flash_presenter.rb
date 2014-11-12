class FlashPresenter < SimpleDelegator
  def initialize(key, value, view)
    super(view)
    @key = key
    @value = value
  end

  def render_flash
  	if @value.is_a?(Array)
  		html = ""
  		@value.each { |msg| html << flash_html(msg) }
  		html.html_safe
  	else
  		flash_html(@value)
  	end
  end

  private

  	def flash_html(msg)
  		content_tag(:div, class: "csw-alert csw-alert-dismissable csw-alert-#{match_flash_key(@key)}") do
	 			content_tag(:a, "&times;".html_safe, class: "csw-close", data: { dismiss: "alert" }, aria_hidden: "true") << msg
			end
  	end

  	def match_flash_key(key)
      puts key.inspect
	  	case key
	  	when "success"
	  		key = "success"
	  	when "error"
	  		key = "danger"
	  	else
	  		key = "info"
	  	end
	  	key
	  end
end