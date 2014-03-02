require 'spec_helper'
describe Api::RolesController do
  it "can start" do
    computer = FactoryGirl.create(:computer) 
    role = FactoryGirl.create(:online_role)

    get "start",{:format => "json",:id => role.id,:ckey => computer.auth_key}
    expect(response).to be_success
    print response.body
    RoleSession.count.should eq 1
    RoleSession.find_by_role_id(role.id).should_not eq nil
  end
  it "can stop"
  it "can reconnect"
  it "can update data"
end
