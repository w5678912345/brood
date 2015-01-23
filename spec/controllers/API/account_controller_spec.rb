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
  it "Auto get account" do
    get :auto,{:format => "json",:ckey => @computer.auth_key,:ip => '127.0.0.1'}
    puts assign(:code)
    started=@account.is_started?
    started.should eq true
    #Account.find_by_no(account.no).phone_id.should eq "12345"
  end
end
