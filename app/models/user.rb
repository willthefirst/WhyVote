class User < ActiveRecord::Base
	attr_accessible :email, :fingerprint
	has_many :posts
  has_many :votes
end
