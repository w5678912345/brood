# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account_profile do
    enable false
    name "MyString"
    anti_check_cfg "MyText"
  end
end
