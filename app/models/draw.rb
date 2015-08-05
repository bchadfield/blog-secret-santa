class Draw < ActiveRecord::Base
  belongs_to :event_id
  belongs_to :group_id
end
