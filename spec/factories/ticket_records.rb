# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ticket_record do
    account "MyString"
    role_id 1
    server "MyString"
    points 1
    gold 1
    msg "MyString"
  end
end
