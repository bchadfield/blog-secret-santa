class Content < ActiveRecord::Base
  include Tokenfindable
	include Tenantable

	belongs_to :match

	scope :published, -> { given.where.not(url: '').order(updated_at: :desc) }

	validates :group_id, presence: true
	validates :url, format: { with: /\A(http|https):\/\/.+/, message: "must start with http:// or https://" }, allow_blank: true

	enum status: [ :draft, :ready, :given ]

	def import_file_contents(file)
    contents = read_file(file)
    self.body = contents if self.errors.empty?
  end

  def not_delivered?
    blank? || (present? && !given?)
  end

  def preview
    Kramdown::Document.new("# #{self.title}\n#{self.body}", auto_ids: false, smart_quotes: 'apos,apos,quot,quot').to_html
  end

  def published?
    given? && url.present?
  end

  private

  	def read_file(file)
      case File.extname(file.original_filename)
      when ".docx"
        begin
          html = Nokogiri::HTML(Docx::Document.open(file.path).to_html).at('body').inner_html.strip
          Kramdown::Document.new(html, input: 'html', smart_quotes: 'apos,apos,quot,quot').to_kramdown.gsub(/\\(['"])/, '\1')
        rescue
          self.errors.add(:file, "isn't a valid docx file and couldn't be imported.")
        end
      when ".md", ".markdown"
        begin
          File.open(file.path).read
        rescue
          self.errors.add(:file, "isn't a supported markdown file and couldn't be imported.")
        end
      else
        self.errors.add(:file, "isn't a supported file type and couldn't be imported.")
      end
    end
end