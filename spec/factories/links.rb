# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :link do
    phone_no Faker::PhoneNumber.phone_number
    event "bslock"
    status "idle"
  end
end
