class Authentication < ActiveRecord::Base
  belongs_to :user

  def self.with_omniauth(auth)
    find_or_create_by(uid: auth['uid'], provider: auth['provider'])
  end
end