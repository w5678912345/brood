require 'spec_helper'
describe Api::AccountController do
  before(:each) do
    load "#{Rails.root}/db/seeds.rb"
    Setting.create :key => 'account_start_roles_count',:val => '5'
    Setting.create :key => 'ip_range_start_count',:val => '1'
    Server.create :name => '测试1区',:role_str => "胡汉三",:goods => "竹笋炒肉",:price => 1000000
    Server.create :name => '测试2区',:role_str => "",:goods => "竹笋炒肉",:price => 1000000
    TopSell.create server_name: '测试1区',role_name:"胡汉三",:goods => "竹笋炒肉",:price => 1000000
    #TopSell.create server_name: '测试1区',:goods => "竹笋炒肉",:price => 1000000
    rp = RoleProfile.where(:name => 'default').first || RoleProfile.create(name: 'default')

    @computer = FactoryGirl.create(:computer)
    @computer1 = FactoryGirl.create(:computer)
    @role = FactoryGirl.create(:role,role_profile: rp)
    @role.update_attributes :total => 0
    @role1 = FactoryGirl.create(:role,:qq_account => @role.qq_account,role_profile: rp)
    @role2 = FactoryGirl.create(:role,role_profile: rp)
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
    #在同一个it内使用的@controller是同一个对象，如果发起多次
    #请求，前次请求会影响后一次的，所以从新new一个出来
    @controller = Api::AccountController.new
    get :auto,@base_params
    assigns(:code).should eq -8

    #ip_used,c段
    @controller = Api::AccountController.new
    get :auto,@base_params.merge(:ip => '127.0.0.2')
    assigns(:code).should eq -8


    #not_find_account
    @controller = Api::AccountController.new

    get :auto,@base_params.merge(:ip => '127.0.1.1',:ckey => @computer1.auth_key)
    assigns(:code).should eq -19
    #当同步信息时带上role_id,将导致此role上线
    @base_params=@base_params.merge(:id => @account0.no,:rid => @role.id)
    get :sync,@base_params.merge(:money_point => 10,:gold => 20,:vit_power => 120,:account_session => {start_count: 10})
    assigns(:code).should eq 1
    Account.find_by_no(@account0.no).money_point.should eq 10
    RoleSession.all.count.should eq 1
    Role.find(@role.id).is_started?.should eq true
    Role.find(@role.id).gold.should eq 20
    Role.find(@role.id).total.should eq 20
    Role.find(@role.id).vit_power.should eq 120

    Note.where(:api_name => '充值').count.should eq 1
    #换角色
    @controller = Api::AccountController.new
    @base_params[:rid]=@role1.id
    get :sync,@base_params.merge({:name => 'role1',:level=> 10,:target => Time.now.to_s})
    HistoryRoleSession.all.count.should eq 1

    #停止
    @controller = Api::AccountController.new
    get :stop,@base_params
    t = Account.find_by_no(@account0.no)
    t.account_session.should be nil
    t.today_success.should be false
    AccountSession.all.count.should eq 1
    RoleSession.all.count.should eq 0
    HistoryRoleSession.all.count.should eq 2
  end
  it "start account" do
    get :start,@base_params.merge(:id => @account0.no)
    assigns(:code).should eq 1

    Account.find_by_no(@account0.no).is_started?.should eq true
    Account.find_by_no(@account0.no).account_session.should_not be nil

    @controller = Api::AccountController.new
    get :start,@base_params.merge(:id => @account0.no)
    assigns(:code).should eq -20
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
    @controller = Api::AccountController.new
    @base_params[:id]=@account0.no
    @base_params[:rid]=@role.id
    get :sync,@base_params.merge({:money_point => 10})
    assigns(:code).should eq 1
    RoleSession.all.count.should eq 1

    #auto Stop
    @controller = Api::AccountController.new
    Account.auto_stop
    Account.find_by_no(@account0.no).is_started?.should eq true


    #auto Stop
    @controller = Api::AccountController.new
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
    @controller = Api::AccountController.new
    get :stop,@base_params.merge(:id => account.no)
    assigns(:code).should eq 1

    #account start again use the same ip
    @controller = Api::AccountController.new
    get :auto,@base_params    
    assigns(:code).should eq 1
    assigns(:account).no.should eq account.no
  end
  it "note change account status" do
    #account start
    get :auto,@base_params    
    assigns(:code).should eq 1
    account = assigns(:account)

    #account note 
    @controller = Api::AccountController.new
    get :note,@base_params.merge(:id => account.no,:status => 'bslocked')
    assigns(:code).should eq 1

    Account.find_by_no(account.no).status.should eq 'bslocked'
    AccountSession.where(:finished => false,:account_id => account.no).first.finished_status.should eq 'bslocked'
  end

  it "note change account status and time" do
    #account start
    get :auto,@base_params    
    assigns(:code).should eq 1
    account = assigns(:account)

    #account note 
    @controller = Api::AccountController.new
    get :note,@base_params.merge(:id => account.no,:status => 'disconnect',:msg => '出现大于一小时制裁,制裁还剩120分钟')
    assigns(:code).should eq 1

    (Account.find_by_no(account.no).normal_at - (120 + 120).minutes.from_now < 1.minutes).should be true
  end

  it "can't get started account" do
    Setting.find_by_key('account_start_roles_count').update_attributes :val => '1'
    #account start
    get :auto,@base_params    
    assigns(:code).should eq 1
    assigns(:account).no.should eq @account0.no

    #account start
    @controller = Api::AccountController.new
    get :auto,@base_params.merge(:ip => '127.0.1.2')    
    assigns(:code).should eq 1
    assigns(:account).no.should eq @account1.no
  end
  it "get the same account" do
    #account start
    get :auto,@base_params    
    assigns(:code).should eq 1
    ac = assigns(:account)
    ac.no.should eq @account0.no
    #use size because it can adapte to call count or length
    assigns(:online_roles).size.should eq 2
    #停止
    @controller = Api::AccountController.new
    get :stop,@base_params.merge(:id => @account0.no)
    Account.find_by_no(@account0.no).is_started?.should eq false
    #second account restart,can get 2 roles too
    @controller = Api::AccountController.new
    get :auto,@base_params    
    assigns(:code).should eq 1
    Account.find_by_no(@account0.no).is_started?.should eq true

    ac = assigns(:account)
    #use size because it can adapte to call count or length
    assigns(:online_roles).size.should eq 2
    Role.find(assigns(:online_roles)[0].id).online.should eq true
    Role.find(assigns(:online_roles)[1].id).online.should eq true

    #role start
    #当同步信息时带上role_id,将导致此role上线
    @base_params=@base_params.merge(:id => @account0.no,:rid => @role.id)
    get :sync,@base_params.merge(:name => 'test_role')
    assigns(:code).should eq 1   

    get :role_stop,@base_params.merge(:success => '1')
    assigns(:code).should eq 1   
    Role.find(@role.id).today_success.should eq true

    #停止
    @controller = Api::AccountController.new
    get :stop,@base_params.merge(:id => @account0.no)
    Account.find_by_no(@account0.no).is_started?.should eq false
    Role.find(@account0.roles[0].id).online.should eq false
    Role.find(@account0.roles[1].id).online.should eq false

    #third restart，beacuse of one finished role now only get one role
    @controller = Api::AccountController.new
    get :auto,@base_params    
    assigns(:code).should eq 1
    ac = assigns(:account)
    ac.no.should eq @account0.no
    #use size because it can adapte to call count or length
    assigns(:online_roles).size.should eq 1


    #stop with sucess,will set normal_at
    @controller = Api::AccountController.new
    get :stop,@base_params.merge(:id => @account0.no,:success => '1')
    ac = Account.find_by_no(@account0.no)
    ac.is_started?.should eq false
    ac.today_success.should eq true
    #ac.normal_at.should > Time.now
  end
  it 'bslocked cooltime check' do
    #account start
    get :auto,@base_params    
    assigns(:code).should eq 1
    ac = assigns(:account)
    ac.no.should eq @account0.no

    @controller = Api::AccountController.new
    get :note,@base_params.merge(:id => ac.no,:status => 'bslocked')   


    @controller = Api::AccountController.new
    get :stop,@base_params.merge(:id => ac.no)
 
    ac = Account.find_by_no(@account0.no)
    ac.is_started?.should eq false
    ac.status.should eq 'bslocked'
    #normal_at will be 72 hours from now
    ac.normal_at.should > 71.hours.from_now
  end

  it 'disconnect cooltime check' do
    #account start
    get :auto,@base_params    
    assigns(:code).should eq 1
    ac = assigns(:account)
    ac.no.should eq @account0.no

    @controller = Api::AccountController.new
    get :note,@base_params.merge(:id => ac.no,:status => 'disconnect',:msg => 'noEnter/StartRoom=-1,-1/CurRoom=-1,-1/BossRoom=-1,-1/verifycode: 出现大于一小时制裁,制裁还剩2166分钟')   


    @controller = Api::AccountController.new
    get :stop,@base_params.merge(:id => ac.no)
 
    ac = Account.find_by_no(@account0.no)
    ac.is_started?.should eq false
    ac.status.should eq 'disconnect'
    #normal_at will be 2166 hours from now
    ac.normal_at.should > 2165.minutes.from_now
  end

  it 'pay without tick_time' do
    get :role_pay,@base_params.merge({:id => @account0.no,:rid => @role.id,:target => 'trader',:gold => '1000',:balance => '123',:pay_type => 'auction'})
    Account.find_by_no(@account0.no).today_pay_count.should eq 1
    Payment.count.should eq 1
    Payment.first.server.should eq @account0.server

    #avoid re send pay data by [role_id,note_id]
    get :role_pay,@base_params.merge({:id => @account0.no,:rid => @role.id,:target => 'trader',:gold => '1000',:balance => '123',:pay_type => 'mail'})
    Account.find_by_no(@account0.no).today_pay_count.should eq 2
    Payment.count.should eq 2
  end
  it 'pay with tick_time' do
    get :role_pay,@base_params.merge({:id => @account0.no,:rid => @role.id,:target => 'trader',:gold => '1000',:balance => '123',:pay_type => 'auction',:tick_time => '123'})
    Payment.count.should eq 1

    #avoid re send pay data by [role_id,note_id]
    get :role_pay,@base_params.merge({:id => @account0.no,:rid => @role.id,:target => 'trader',:gold => '1000',:balance => '123',:pay_type => 'auction',:tick_time => '123'})
    Payment.count.should eq 1

    #note_id is different,then accept
    get :role_pay,@base_params.merge({:id => @account0.no,:rid => @role.id,:target => 'trader',:gold => '1000',:balance => '123',:pay_type => 'auction',:tick_time => '1234'})
    Payment.count.should eq 2
  end
  it 'can get gold_agent' do
    @account0.update_attributes :gold_agent_name => @role2.name ,:server => '测试1区'
    get :gold_agent,@base_params.merge({:id => @account0.no})

    assigns(:result)[0][:name].should eq @role2.name
    assigns(:result)[0][:price].should eq 1000000
    assigns(:result)[0][:account_status].should eq @role2.qq_account.status
    assigns(:result)[0][:role_status].should eq @role2.status
  end
  it 'can get server gold_agent' do
    @account0.update_attributes :gold_agent_name => Api::BaseController.LAST_GOLD_AGENT_NAME,:server => '测试1区'
    get :gold_agent,@base_params.merge({:id => @account0.no})

    assigns(:result)[0][:name].should eq "胡汉三"
    assigns(:result)[0][:goods].should eq "竹笋炒肉"
    assigns(:result)[0][:price].should eq 1000000
    assigns(:result)[0][:account_status].should eq "normal"
    assigns(:result)[0][:role_status].should eq "normal"
  end

  it 'can not get server gold_agent' do
    TopSell.update_all(:enable => false)
    @account0.update_attributes :gold_agent_name => Api::BaseController.LAST_GOLD_AGENT_NAME,:server => '测试1区'
    get :gold_agent,@base_params.merge({:id => @account0.no})

    assigns(:result)[0].should eq nil
  end


  it 'can not get gold_agent when server.enable_transfer_gold is false' do
    Server.find_by_name("测试1区").update_attributes :enable_transfer_gold => false
    @account0.update_attributes :gold_agent_name => @role2.name,:server => '测试1区'
    get :gold_agent,@base_params.merge({:id => @account0.no})
    assigns(:result)[0].should eq nil
  end
  it 'can not get gold_agent when there is no server agent set' do
    @account0.update_attributes :gold_agent_name => Api::BaseController.LAST_GOLD_AGENT_NAME,:server => '测试2区'
    get :gold_agent,@base_params.merge({:id => @account0.no})
    assigns(:result)[0].should eq nil
  end
  it 'can not get gold_agent when server.enable_transfer_gold is false' do
    Server.find_by_name("测试1区").update_attributes :enable_transfer_gold => false
    @account0.update_attributes :gold_agent_name => Api::BaseController.LAST_GOLD_AGENT_NAME,:server => '测试1区'
    get :gold_agent,@base_params.merge({:id => @account0.no})
    assigns(:result)[0].should eq nil
  end
  it 'can get direct_gold_agent when server.enable_transfer_gold is true' do
    AppSettings.title.should_not eq 'tian2'
    Server.create(:name => '重庆2区',:enable_transfer_gold => true,:goods => 'test1',:price => 11111)
    TopSell.create(:role_name => "noname",:server_name => '重庆2区',:goods => 'test',:price => 10000)

    @account0.update_attributes :gold_agent_name => "收币直通车",:server => '重庆2区'

    get :gold_agent,@base_params.merge({:id => @account0.no})
    assigns(:result).first.should be nil 


    DirectGoldAgent.create(:server_id => '重庆2区',:role_name => '雪白小',:enable => true)

    get :gold_agent,@base_params.merge({:id => @account0.no})
    assigns(:result)[0][:name].should eq '雪白小'
    assigns(:result)[0][:goods].should eq 'test1'
    assigns(:result)[0][:price].should eq 11111
  end

end
