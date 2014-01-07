require 'spec_helper'
describe "Api::ComputersController" do
  it "Can start" do
    @time_now = Time.parse("Feb 24 1981")
    Time.stub(:now).and_return(@time_now)

  	computer = FactoryGirl.create(:computer,:checked => true) 
    computer.created_at.should eql(@time_now)

    get "/api/computers/start",{:format => "json",:ckey => computer.auth_key}
    expect(response).to be_success
    #binding.pry
    expect(response.status).to eq(200)
    @expected = { 
        :code  => 1
		}.to_json
    response.body.should == @expected
  end
end
