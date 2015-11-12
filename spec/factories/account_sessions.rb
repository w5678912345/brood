# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account_session do
    created_at "2015-01-27 11:21:12"
    started_status "MyString"
    finished_at "2015-01-27 11:21:12"
    finished false
    finished_status "MyString"
    remark "MyString"
  end
end
