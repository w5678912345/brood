# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :role do
    name "user1"
    #email "user1@126.com"
    password "12345678"
    level 23
    total 2000000
    vit_power 156
    online 0
    session_id 0
  	association :qq_account,factory: :account
  end
  factory :online_role,:parent => :role do
    online 1
  	association :qq_account,factory: :online_account
  end
  factory :online_session_role,:parent => :online_role do
    role_session
  end
end
