# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :role do
  	name "user1"
  	password "12345678"
  	account "123456789"
  	level 35
  end
end
