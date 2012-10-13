class User < ActiveRecord::Base
	acts_as_voter
	attr_accessible :email
	belongs_to :post
end
