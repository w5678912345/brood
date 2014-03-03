require 'spec_helper'
describe Api::RolesController do
  def fake_role_start(role = nil)
    role = FactoryGirl.create(:online_role) if role.nil?

    get "start",{:format => "json",:id => role.id,:ckey => role.qq_account.online_computer.auth_key}
    role
  end
  it "can start" do
    role = fake_role_start
    expect(response).to be_success

    RoleSession.count.should eq 1
    session = RoleSession.find_by_role_id(role.id)
    session.should_not eq nil
    session.start_level.should eq role.level
    session.start_gold.should eq role.total
    session.used_gold.should eq 0
    session.exchanged_gold.should eq 0
  end
  it "can stop" do
    role = fake_role_start
    get "stop" ,{:format => "json",:id => role.id,:ckey => role.qq_account.online_computer.auth_key}  
    RoleSession.count.should eq 0
  end
  it "can reconnect" do
    role = fake_role_start
    fake_role_start(role)
    RoleSession.count.should eq 1
  end
  it "can update data" do
    role = fake_role_start
    get "sync" ,{:format => "json",:id => role.id,:ckey => role.qq_account.online_computer.auth_key}    
    session = RoleSession.find_by_role_id(role.id)
    
  end
end
