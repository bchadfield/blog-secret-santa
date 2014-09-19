module Tokenfindable
  extend ActiveSupport::Concern

  included do
  	before_validation(on: :create) { generate_token(:token) }

  	validates :token, presence: true
  end

  def to_param
  	token
  end

  private

	  def generate_token(column)
	  	if self[column].blank?
		    self[column] = loop do
		      random_token = SecureRandom.urlsafe_base64.gsub(/[_-]/,"")
		      break random_token unless self.class.unscoped.exists?(column => random_token)
		    end
		  end
	  end

end