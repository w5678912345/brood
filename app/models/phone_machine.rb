class PhoneMachine < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :phones
end
