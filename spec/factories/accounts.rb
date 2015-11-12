# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account do
	sequence(:no){|n| "account#{n}"} 
	password "pwd11111"
  end
  factory :online_account,:parent => :account do
	association :online_computer,factory: :computer
  	association :session,factory: :account_session 
  end
end
