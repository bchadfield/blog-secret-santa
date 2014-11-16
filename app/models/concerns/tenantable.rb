module Tenantable
  extend ActiveSupport::Concern

  included do 
  	belongs_to :group
  	
		default_scope { where(group_id: Group.current_id) if Group.current_id }
	end
end