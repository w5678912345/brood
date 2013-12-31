require 'spec_helper'
describe Api::AccountController do
  it "Can start" do
  	computer = FactoryGirl.create(:computer) 

    get "start",{:format => "json",:ckey => computer.auth_key}
    expect(response).to be_success
    #binding.pry
    expect(response.status).to eq(200)
  end
  it "can use money test" do
  	pay1 = FactoryGirl.create(:payment,{:role_id => 1,:note_id => 1})
  	#print(pay1.amount,"\n")
  end
end
