require 'spec_helper'
describe Api::AccountController do
  it "bind_phone success" do
    account = FactoryGirl.create(:account)

    get :bind_phone,{:format => "json",:id => account.no,:phone_no => "12345"}
    print Account.find_by_no(account.no).no
    Account.find_by_no(account.no).phone_id.should eq "12345"
  end

end
