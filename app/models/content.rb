class Content < ActiveRecord::Base
  include Tokenfindable
	include Tenantable

	belongs_to :match

	scope :published, -> { given.where.not(url: nil).order(updated_at: :desc) }

	validates :pool_id, presence: true
	validates :url, format: { with: /\A(http|https):\/\/.+/, message: "must start with http:// or https://" }, allow_nil: true

	enum status: [ :draft, :ready, :given ]
end