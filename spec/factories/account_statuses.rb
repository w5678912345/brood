# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account_status do
    status "MyString"
    hours 1
  end
end
