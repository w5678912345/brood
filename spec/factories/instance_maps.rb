# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :instance_map do
    sequence(:key){|n| "123#{n}"} 
    name "MyString"
    min_level 1
    max_level 1
    gold 1
    enabled true
    safety_limit 1
    death_limit 1
    enter_count 0
    remark "MyString"
  end
end
