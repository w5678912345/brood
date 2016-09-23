require 'spec_helper'
describe Api::RolesController do
  def fake_role_start(role = nil)
    role = FactoryGirl.create(:online_role) if role.nil?
    print role.id
    get "start",{:format => "json",:id => role.id,:ckey => role.qq_account.online_computer.auth_key,:ip => '127.0.0.1'}
    role
  end
  it "can start" do
    update_time = 15.minutes.ago
    Time.stub(:now) { update_time }

    role = fake_role_start
    expect(response).to be_success

    RoleSession.count.should eq 1
    session = RoleSession.find_by_role_id(role.id)
    session.should_not eq nil
    session.start_level.should eq role.level
    session.start_gold.should eq role.total
    session.start_power.should eq role.vit_power
    session.used_gold.should eq 0
    session.exchanged_gold.should eq 0
    session.live_at.to_i.should eq update_time.to_i
    session.ip.should eq '127.0.0.1'
  end
  it "can stop" do
    role = fake_role_start
    back_session = role.role_session
    get "stop" ,{:format => "json",:id => role.id,:msg => "success",:ckey => role.qq_account.online_computer.auth_key}
    RoleSession.count.should eq 0
    HistoryRoleSession.count.should eq 1
    hs = HistoryRoleSession.first
    hs.begin_level.should eq back_session.start_level
    hs.end_level.should eq role.level
    hs.result.should eq "success"
  end
  it "can reconnect" do
    role = fake_role_start
    fake_role_start(role)
    RoleSession.count.should eq 1
  end
  it "can update data" do
    role = fake_role_start

    update_time = 15.minutes.ago
    Time.stub(:now) { update_time }
    get "sync" ,{:format => "json",:id => role.id,:ckey => role.qq_account.online_computer.auth_key}    
    session = RoleSession.find_by_role_id(role.id)
    session.live_at.to_i.should eq update_time.to_i
  end
  it "will auto stop if timeout" do
    role = fake_role_start

    #get "sync" ,{:format => "json",:id => role.id,:ckey => role.qq_account.online_computer.auth_key}    

    update_time1 = 15.minutes.from_now
    Time.stub(:now) { update_time1 }
    Role.auto_stop
    RoleSession.count.should eq 0
  end
end
