# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :role_session do
    role_id 1
    computer_id 1
    start_level 1
    start_gold 1
    start_exp 1
    used_gold 1
    exchanged_gold 1
    task "MyString"
    connection_times 1
    live_at "2014-03-02 21:04:26"
  end
end
