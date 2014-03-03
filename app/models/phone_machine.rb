class PhoneMachine < ActiveRecord::Base
  attr_accessible :name
  has_many :phones
end
