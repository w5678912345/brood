# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :daily_record do
    date "2015-02-14"
    account_start_count 1
    role_start_count "MyString"
    success_role_count 1
    consumed_vit_power_sum 1
    role_online_hours 1
    gold 1
    trade_gold 1
    bslocked_count 1
    discardforyears_count 1
    discardfordays_count 1
    exception_count 1
    recycle 1
    locked 1
  end
end
