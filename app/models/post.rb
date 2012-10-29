require 'statistics2'

class Post < ActiveRecord::Base
  attr_accessible :candidate, :reason, :popularity, :legit, :user_attributes
  has_many :votes
  belongs_to :user
  accepts_nested_attributes_for :user, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true

  def self.ci_lower_bound(pos, n, confidence)
    return 0 if n == 0
    z = Statistics2.pnormaldist(1-(1-confidence)/2)
    phat = 1.0*pos/n
    (phat + z*z/(2*n) - z * Math.sqrt((phat*(1-phat)+z*z/(4*n))/n))/(1+z*z/n)
  end
end