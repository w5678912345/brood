require 'spec_helper'
describe Api::AccountController do
	before(:each) do
  	@computer = FactoryGirl.create(:computer)
  	@computer.checked = true
  	@computer.max_accounts = 12
  	@computer.save!
    @role = FactoryGirl.create(:role)
    @computer.accounts << @role.qq_account
    @computer.save
    @account = @role.qq_account
	end
  it "Auto start account" do
    get :auto,{:format => "json",:ckey => @computer.auth_key,:ip => '127.0.0.1'}
    
    assigns(:code).should eq 1
    Account.find_by_no(@account.no).is_started?.should eq true
    
    get :sync,{:format => "json",:ckey => @computer.auth_key,:ip => '127.0.0.1',
      id: @account.no,
      :money_point => 10
    }
    assigns(:code).should eq 1
    Account.find_by_no(@account.no).money_point.should eq 10

    #ip_used,c段
    get :auto,{:format => "json",:ckey => @computer.auth_key,:ip => '127.0.0.1'}
    assigns(:code).should eq -8

    #not_find_account
    get :auto,{:format => "json",:ckey => @computer.auth_key,:ip => '127.0.1.2'}
    assigns(:code).should eq -19
    
  end
  it "get role profile" do
    get :role_profile,{:format => "json",:ckey => @computer.auth_key,:id => @account.id,:rid => @role.id,:ip => '127.0.0.1'}
    assigns(:pf).should eq @role.role_profile
  end
end
