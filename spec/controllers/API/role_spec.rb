require 'spec_helper'
describe Api::RolesController do
  it "can start" do
    computer = FactoryGirl.create(:computer) 
    role = FactoryGirl.create(:online_role)

    get "start",{:format => "json",:id => role.id,:ckey => computer.auth_key}
    expect(response).to be_success
    print response.body
    RoleSession.count.should eq 1
    session = RoleSession.find_by_role_id(role.id)
    session.should_not eq nil
    session.start_level.should eq role.level
  end
  it "can stop"
  it "can reconnect"
  it "can update data"
end
