require 'spec_helper'
describe Api::AccountController do
  before(:each) do
    Setting.create :key => 'account_start_roles_count',:val => '5'
    @computer = FactoryGirl.create(:computer)
    @computer.checked = true
    @computer.max_accounts = 12
    @computer.save!
    @role = FactoryGirl.create(:role)
    @role1 = FactoryGirl.create(:role,:qq_account => @role.qq_account)
    Role.all.count.should eq 2

    @computer.accounts << @role.qq_account
    @computer.save
    @account = @role.qq_account
    @account.account_session.should be nil
  end
  it "Auto start account" do
    base_params = {:format => "json",:ckey => @computer.auth_key,:ip => '127.0.0.1'}
    
    get :auto,base_params    
    assigns(:code).should eq 1

    Account.find_by_no(@account.no).is_started?.should eq true
    Account.find_by_no(@account.no).account_session.should_not be nil
    #ip_used
    get :auto,base_params
    assigns(:code).should eq -8

    #ip_used,c段
    get :auto,base_params.merge(:ip => '127.0.0.2')
    assigns(:code).should eq -8


    #not_find_account
    get :auto,base_params.merge(:ip => '127.0.1.1')
    assigns(:code).should eq -19
    base_params[:id]=@account.no
    #当同步信息时带上role_id,将导致此role上线
    base_params[:rid]=@role.id
    get :sync,base_params.merge({:money_point => 10})
    assigns(:code).should eq 1
    Account.find_by_no(@account.no).money_point.should eq 10
    RoleSession.all.count.should eq 1
    Role.find(@role.id).is_started?.should eq true

    #换角色
    base_params[:rid]=@role1.id
    get :sync,base_params.merge({:name => 'role1',:level=> 10,:target => Time.now.to_s})
    HistoryRoleSession.all.count.should eq 1

    get :stop,base_params
    Account.find_by_no(@account.no).account_session.should be nil
    AccountSession.all.count.should eq 1
    RoleSession.all.count.should eq 0
    HistoryRoleSession.all.count.should eq 2
  end
  it "get role profile" do
    get :role_profile,{:format => "json",:ckey => @computer.auth_key,:id => @account.id,:rid => @role.id,:ip => '127.0.0.1'}
    assigns(:pf).should eq @role.role_profile
  end
  it "auto account stop" do 
    base_params = {:format => "json",:ckey => @computer.auth_key,:ip => '127.0.0.1'}
    
    #account start
    get :auto,base_params    
    assigns(:code).should eq 1
    Account.find_by_no(@account.no).is_started?.should eq true
    Account.find_by_no(@account.no).account_session.should_not be nil

    #role start
    base_params[:id]=@account.no
    base_params[:rid]=@role.id
    get :sync,base_params.merge({:money_point => 10})
    assigns(:code).should eq 1
    RoleSession.all.count.should eq 1

    #auto Stop
    Account.auto_stop 1.hour.from_now

    Account.find_by_no(@account.no).account_session.should be nil
    AccountSession.all.count.should eq 1
    RoleSession.all.count.should eq 0
  end
  it ""
end
