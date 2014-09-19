class Content < ActiveRecord::Base
  include Tokenfindable
	acts_as_tenant(:pool)

	belongs_to :pool
	belongs_to :match

	scope :published, -> { given.where.not(url: nil).order(updated_at: :desc) }

	validates :url, format: { with: /\A(http|https):\/\/.+/, message: "must start with http:// or https://" }, allow_nil: true

	enum status: [ :draft, :ready, :given ]
end