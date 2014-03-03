# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :phone do
  	sequence(:id){|n| "12312#{n}"} 
  end
end
