class Match < ActiveRecord::Base
	acts_as_tenant(:pool)
	
	belongs_to :pool
	belongs_to :giver, class_name: "User"
	belongs_to :receiver, class_name: "User"
	has_one :content
	
end
