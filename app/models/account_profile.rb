class AccountProfile < ActiveRecord::Base
  attr_accessible :anti_check_cfg, :enable, :name, :comment
  has_many :accounts
end
