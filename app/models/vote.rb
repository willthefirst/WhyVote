class Vote < ActiveRecord::Base
  attr_accessible :positive
  belongs_to :post
  belongs_to :user
end