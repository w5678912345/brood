# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
  	name "user1"
  	email "user1@126.com"
  	password "12345678"
  	password_confirmation "12345678"
  end
  factory :admin,:parent => :user do
  	name "admin1"
  	email "admin@125.com"

  	is_admin true
  end
end
