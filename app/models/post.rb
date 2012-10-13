class Post < ActiveRecord::Base
  attr_accessible :candidate, :reason, :user_attributes
  has_one :user
  acts_as_voteable
  accepts_nested_attributes_for :user, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true
end
