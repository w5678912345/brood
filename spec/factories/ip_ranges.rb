# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ip_range do
    ip "MyString"
    start_count 1
    minutes 1
    online_count 1
    ip_accounts_in_24_hours 1
    enabled false
    remark "MyString"
  end
end
