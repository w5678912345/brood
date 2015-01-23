# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :role_profile do
    name "MyString"
    data "MyText"
    roles_count 1
    version 1
  end
end
