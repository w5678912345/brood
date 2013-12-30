# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :payment do
  	gold 12212
  	balance 10000
  	total 22212
  	pay_type "trade"
  end
end
