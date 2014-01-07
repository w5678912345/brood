require 'spec_helper'
describe Api::ComputersController do


	describe "get computer info" do

		it "get a exists computer by ckey" do
        	computer = FactoryGirl.create(:computer)      
          	get :cinfo, {:format => "json",:ckey => computer.auth_key}
        	 expect(response.status).to eq(200)
        	assigns(:computer).should eq computer
      	end

      	it "get a not exists computer by ckey" do
      		 get :cinfo, {:format => "json",:ckey => "hello"}
      		 response.should be_success
           assigns(:computer).should be_nil
         #   body = response.to_json
         #   code = body['code']
      		 # code.should eq -4

          # JSON.parse(response.body).first.keys.include?("code").should == -4
      	end

	end

end