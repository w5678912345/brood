require 'spec_helper'

describe Api::MapsController do

	describe "GET valid" do

		it "not find role" do 
			#expect  get :pull,{}} be {"code" : -3}
		end

    	it "can pull valid a map" do
        @role = FactoryGirl.create(:role,:level=>10)
        @map = FactoryGirl.create(:instance_map, :min_level => 10,:max_level=>20)

     		get :valid, {:role_id=>@role.id}
        assigns(:map).should eq @map
    	end

    	it "can not pull valid a map" do
    		@role = FactoryGirl.create(:role,:level=>30)
        @map = FactoryGirl.create(:instance_map, :min_level => 10,:max_level=>20)
        get :valid, {:role_id => @role.id}
        assigns(:map).should eq nil
    	end

      it "can pull a valid and best map" do
      end
 	end

end