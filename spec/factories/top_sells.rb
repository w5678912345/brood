# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :top_sell do
    server_name "MyString"
    role_name "MyString"
    gold "MyString"
    price 1
    today_sells_count 1
    today_sells_sum 1
  end
end
