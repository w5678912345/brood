# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account do
	sequence(:no){|n| "account#{n}"} 
	password "pwd11111"
	phone
  end
  factory :online_account,:parent => :account do
  	association :session,factory: :note 
  end
end
