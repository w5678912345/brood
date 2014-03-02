# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
  	sequence(:name){|i| "user1%d" % i} 
  	sequence(:email){|i| "user%d@126.com" % i} 
  	password "12345678"
  	password_confirmation "12345678"
  end
  factory :admin,:parent => :user do
  	name "admin1"
  	email "admin@125.com"

  	is_admin true
  end
end
