require 'spec_helper'
describe Api::AccountController do
  before(:each) do
    Setting.create :key => 'account_start_roles_count',:val => '5'
    Setting.create :key => 'ip_range_start_count',:val => '1'

    @computer = FactoryGirl.create(:computer)
    @computer1 = FactoryGirl.create(:computer)
    @role = FactoryGirl.create(:role)
    @role1 = FactoryGirl.create(:role,:qq_account => @role.qq_account)
    @role2 = FactoryGirl.create(:role)
    @computer.accounts << @role.qq_account
    @computer.accounts << @role2.qq_account

    @computer.save
    @account0 = @role.qq_account
    @account1 = @role2.qq_account
    @account0.account_session.should be nil

    @base_params = {:format => "json",:ckey => @computer.auth_key,:ip => '127.0.0.1'}

  end
  it "Auto start account" do    
    get :auto,@base_params    
    assigns(:code).should eq 1

    Account.find_by_no(@account0.no).is_started?.should eq true
    Account.find_by_no(@account0.no).account_session.should_not be nil
    #ip_used
    @controller = Api::AccountController.new
    get :auto,@base_params
    assigns(:code).should eq -8

    #ip_used,c段
    @controller = Api::AccountController.new
    get :auto,@base_params.merge(:ip => '127.0.0.2')
    assigns(:code).should eq -8


    #not_find_account
    get :auto,@base_params.merge(:ip => '127.0.1.1',:ckey => @computer1.auth_key)
    assigns(:code).should eq -19
    @base_params[:id]=@account0.no
    #当同步信息时带上role_id,将导致此role上线
    @base_params[:rid]=@role.id
    get :sync,@base_params.merge({:money_point => 10})
    assigns(:code).should eq 1
    Account.find_by_no(@account0.no).money_point.should eq 10
    RoleSession.all.count.should eq 1
    Role.find(@role.id).is_started?.should eq true

    #换角色
    @base_params[:rid]=@role1.id
    get :sync,@base_params.merge({:name => 'role1',:level=> 10,:target => Time.now.to_s})
    HistoryRoleSession.all.count.should eq 1

    get :stop,@base_params
    t = Account.find_by_no(@account0.no)
    t.account_session.should be nil
    t.today_success.should be false
    AccountSession.all.count.should eq 1
    RoleSession.all.count.should eq 0
    HistoryRoleSession.all.count.should eq 2
  end
  it "get role profile" do
    get :role_profile,@base_params.merge(:id => @account0.id,:rid => @role.id)
    assigns(:pf).should eq @role.role_profile
  end
  it "auto account stop" do 
    #account start
    get :auto,@base_params    
    assigns(:code).should eq 1
    Account.find_by_no(@account0.no).is_started?.should eq true
    Account.find_by_no(@account0.no).account_session.should_not be nil

    #role start
    @base_params[:id]=@account0.no
    @base_params[:rid]=@role.id
    get :sync,@base_params.merge({:money_point => 10})
    assigns(:code).should eq 1
    RoleSession.all.count.should eq 1

    #auto Stop
    Account.auto_stop 1.hour.from_now

    Account.find_by_no(@account0.no).account_session.should be nil
    AccountSession.all.count.should eq 1
    RoleSession.all.count.should eq 0
  end
  it "get one role status is normal account" do
    @role.update_attributes :status => :disable
    #account start
    get :auto,@base_params    
    assigns(:code).should eq 1
    Account.find_by_no(@account0.no).is_started?.should eq true  
  end

  it "can't get all role status is not normal account" do
    @account0.roles.update_all :status => :disable

    #account start
    get :auto,@base_params    
    assigns(:code).should eq 1
    Account.find_by_no(@account1.no).is_started?.should eq true  
  end
  it "can't get account status is not normal account" do
    @account0.update_attributes :status => :recycle
    @account0.can_start?.should eq true
    @account0.update_attributes :normal_at => 1.day.from_now
    @account0.can_start?.should eq false
    #account start
    get :auto,@base_params    
    assigns(:code).should eq 1
    assigns(:account).no.should eq @account1.no
  end
  it "can get the same ip account" do
    #account start
    get :auto,@base_params    
    assigns(:code).should eq 1
    account = assigns(:account)
    #account stop
    get :stop,@base_params.merge(:id => account.no)
    assigns(:code).should eq 1

    #account start again use the same ip
    get :auto,@base_params    
    assigns(:code).should eq 1
    assigns(:account).no.should eq account.no
  end
end
