class PhoneTask < ActiveRecord::Base
  attr_accessible :action, :msg, :phone_id, :status,:target,:result
  belongs_to :phone
end
