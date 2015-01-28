# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :computer do
  	sequence(:hostname){|n| "computer#{n}"} 
  	sequence(:auth_key){|n| "05A1-0DFF-9D99-6D15-942C-2B06-EBCE-8F9#{n}"} 
    checked true
    max_accounts 12
  	server '浙江1区'
  	user
  end
end
