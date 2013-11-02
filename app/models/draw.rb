class Draw < ActiveRecord::Base
	has_many :secret_santas
	has_many :content
end
