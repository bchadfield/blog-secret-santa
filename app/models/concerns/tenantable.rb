module Tenantable
  extend ActiveSupport::Concern

  included do 
  	belongs_to :pool
  	
		default_scope { where(pool_id: Pool.current_id) if Pool.current_id }
	end
end