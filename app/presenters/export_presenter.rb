class ExportPresenter < SimpleDelegator
  
  def initialize(content)
    @content = content
  end
  
  def render_content_for_export(ext)
    puts "EXTENTION#{ext}"
    begin
      filename = @content.title.present? ? @content.title.parameterize : "your-exported-gift"
      { 
        output: method("parse_for_#{ext}").call, 
        filename: "#{filename}.#{file_extention(ext)}", 
        type: '#{file_type(ext)}; charset=utf-8'
      }
    rescue NameError => e
      @content.errors[:base] << "You're trying to export to a file type that isn't supported. Error: #{e}"
    end
  end

  private

    def parse_for_text
      html = Kramdown::Document.new("# #{@content.title}\n#{@content.body}", auto_ids: false, smart_quotes: 'apos,apos,quot,quot').to_html
      ActionController::Base.helpers.strip_tags(html).gsub(/^( |\t)+/, "")
    end

    def parse_for_markdown
      "# #{@content.title}\n\n#{@content.body}"
    end

    def parse_for_html
      html = Kramdown::Document.new("# #{@content.title}\n#{@content.body}", auto_ids: false, smart_quotes: 'apos,apos,quot,quot').to_html
      html.encode("cp1252").force_encoding("UTF-8")
    end

    def file_type(ext)
      case ext
      when "html"
        'text/html'
      when "text"
        'text/plain'
      when "markdown"
        'text/markdown'
      end
    end

    def file_extention(ext)
      case ext
      when "html", "markdown"
        ext
      when "text"
        'txt'
      end
    end
end