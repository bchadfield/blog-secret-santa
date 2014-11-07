class Match < ActiveRecord::Base
	include Tenantable

	belongs_to :giver, class_name: "User"
	belongs_to :receiver, class_name: "User"
	has_one :content

	validates :pool_id, presence: true
	
end
