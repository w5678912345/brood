class AccountProfile < ActiveRecord::Base
  attr_accessible :anti_check_cfg, :enable, :name
  has_many :accounts
end
