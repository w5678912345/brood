require 'spec_helper'

describe Api::MapsController do
    describe "GET valid" do

    it "can pull valid a map by level range" do
        @role = FactoryGirl.create(:online_session_role,:level=>10)
        @map = FactoryGirl.create(:instance_map, :min_level => 10,:max_level=>20,:enter_count=>0)
     	get :valid, {:role_id=>@role.id}
        RoleSession.find_by_role_id(@role.id).instance_map_id.should eq @map.id
        assigns(:map).enter_count.should eq 1
        #TODO 同样的角色去取2次，会导致计数增加，需要修改
        get :valid, {:role_id=>@role.id}
        InstanceMap.first.enter_count.should eq 2
        assigns(:map).enter_count.should eq 2
	end

	it "can not pull valid a map" do
		@role = FactoryGirl.create(:online_session_role,:level=>30)
        @map = FactoryGirl.create(:instance_map, :min_level => 10,:max_level=>20)
        get :valid, {:role_id => @role.id}
        assigns(:map).should eq nil
        assigns(:code).should eq -1
	end

    it "can pull a map when enter_count >= safe_count and enter_count < death_limit" do
        @role1 = FactoryGirl.create(:online_session_role,:level=>10)
        @role2 = FactoryGirl.create(:online_session_role,:level=>11)
        RoleSession.count.should eq 2
        @map = FactoryGirl.create(:instance_map,:min_level => 10,:max_level => 20,:safety_limit=>1,:death_limit => 2,:enter_count=>0)
        get :valid, {:role_id => @role1.id}
        assigns(:map).should eq @map
        get :valid, {:role_id => @role2.id}
        assigns(:map).should eq @map
    end

    it "pull a safe map first" do
        @role1 = FactoryGirl.create(:online_session_role,:level=>10)
        @role2 = FactoryGirl.create(:online_session_role,:level=>11)

        @map1 = FactoryGirl.create(:instance_map,:min_level => 10,:max_level => 20,:safety_limit=>1,:death_limit => 1,:enter_count=>0)
        @map2 = FactoryGirl.create(:instance_map,:min_level => 10,:max_level => 20,:safety_limit=>1,:death_limit => 2,:enter_count=>0)

        get :valid, {:role_id => @role1.id}
        assigns(:map).should eq @map1
        get :valid, {:role_id => @role2.id}
        assigns(:map).should eq @map2
    end

    it "can not pull a map when enter_count >= death_limit" do
        @role1 = FactoryGirl.create(:online_session_role,:level=>10)
        @role2 = FactoryGirl.create(:online_session_role,:level=>11)
        RoleSession.count.should eq 2
        @map = FactoryGirl.create(:instance_map,:min_level => 10,:max_level => 20,:safety_limit=>1,:death_limit => 1,:enter_count=>0)
        get :valid, {:role_id => @role1.id}
        assigns(:map).should eq @map
        get :valid, {:role_id => @role2.id}
        assigns(:map).should eq nil
    end

    it "pull a best map" do 
        @role = FactoryGirl.create(:online_session_role,:level=>10)
        @map1 = FactoryGirl.create(:instance_map,:min_level => 10,:max_level => 20,:gold=>10000)
        @map2 = FactoryGirl.create(:instance_map,:min_level => 10,:max_level => 20,:gold=>20000)
        get :valid, {:role_id => @role.id}
        assigns(:map).should eq @map2
    end

    # it "can pull a map enter_count >= safety_limit" do 
    # end





 	end

end