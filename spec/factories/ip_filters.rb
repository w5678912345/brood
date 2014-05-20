# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ip_filter do
    regex "MyString"
    enabled false
    reverse false
  end
end
