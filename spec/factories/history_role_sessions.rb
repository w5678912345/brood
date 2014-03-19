# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :history_role_session do
    id 1
    begin_at "2014-03-10 18:05:31"
    end_at "2014-03-10 18:05:31"
    gold 1
    exchanged_gold 1
    connection_times 1
    ip "MyString"
    task "MyString"
    result "MyString"
    role_id 1
    account_id 1
    computer_id 1
    role_name "MyString"
    begin_level 1
    end_level 1
    begin_power 1
    end_power 1
    account_key "MyString"
    server "MyString"
    version "MyString"
    game_version "MyString"
  end
end
