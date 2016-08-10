require 'spec_helper'

describe Api::MapsController do
    before :each do
        request.env["HTTP_ACCEPT"] = 'application/json'
    end
    describe "GET valid" do
        it "can pull valid a map by level range" do
            @role = FactoryGirl.create(:online_session_role,:level=>10)
            @map = FactoryGirl.create(:instance_map, :min_level => 10,:max_level=>20,:enter_count=>0)
         	get :valid, {:role_id=>@role.id}
            RoleSession.find_by_role_id(@role.id).instance_map_id.should eq @map.id
            #reload是为了把counter_cache的数值加载起来
            assigns(:map).reload.enter_count.should eq 1
            #TODO 同样的角色去取2次，会导致计数增加，需要修改!(此问题已经没有了)
            get :valid, {:role_id=>@role.id}
            InstanceMap.first.enter_count.should eq 1
    	end
        it "can one manual pull client_manual map" do
            @role = FactoryGirl.create(:online_session_role,:level=>10)
            @map = FactoryGirl.create(:instance_map,:name=>"map1", :min_level => 10,:max_level=>20,:enter_count=>0,:client_manual => true)
            get :valid, {:role_id=>@role.id}
            RoleSession.find_by_role_id(@role.id).instance_map_id.should eq nil
            #reload是为了把counter_cache的数值加载起来
            assigns(:map).should eq nil
            #TODO 同样的角色去取2次，会导致计数增加，需要修改!(此问题已经没有了)
            get :valid, {:role_id=>@role.id,:expect_map_name => "map1"}
            assigns(:map).should eq @map
        end

    	it "can not pull valid a map if level not in range" do
    		@role = FactoryGirl.create(:online_session_role,:level=>30)
            @map = FactoryGirl.create(:instance_map, :min_level => 10,:max_level=>20)
            get :valid, {:role_id => @role.id}
            assigns(:map).should eq nil
            assigns(:code).should eq -1
    	end

        it "can not pull valid a map if in exgroup" do
            @role = FactoryGirl.create(:online_session_role,:level=>15)
            @map = FactoryGirl.create(:instance_map, :group => 'anton',:min_level => 10,:max_level=>20)
            get :valid, {:role_id => @role.id,:exgroup => 'anton'}
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
            assigns(:map).reload.enter_count.should eq 2
        end

        it "pull a safe map first" do
            @role2 = FactoryGirl.create(:online_session_role,:level=>11)

            @map1 = FactoryGirl.create(:instance_map,:min_level => 10,:max_level => 20,:safety_limit=>1,:death_limit => 1,:enter_count=>1)
            @map2 = FactoryGirl.create(:instance_map,:min_level => 10,:max_level => 20,:safety_limit=>1,:death_limit => 2,:enter_count=>0)

            get :valid, {:role_id => @role2.id}
            assigns(:map).should eq @map2
        end

        it "can not pull a map when enter_count >= death_limit" do
            @role2 = FactoryGirl.create(:online_session_role,:level=>11)
            RoleSession.count.should eq 1
            @map = FactoryGirl.create(:instance_map,:min_level => 10,:max_level => 20,:safety_limit=>1,:death_limit => 1,:enter_count=>1)
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
    describe "GET all_valid" do
        it "can pull all valid maps" do
            @role = FactoryGirl.create(:online_session_role,:level=>12)
            @map1 = FactoryGirl.create(:instance_map,:min_level => 10,:max_level => 20,:gold=>10000)
            @map2 = FactoryGirl.create(:instance_map,:min_level => 5,:max_level => 150,:gold=>20000)
            get :index, {:role_id => @role.id}
            assigns(:maps).count.should eq 2
        end
        it "can pull no valid maps" do
            @role = FactoryGirl.create(:online_session_role,:level=>12,:profession => 'gunner')
            @map1 = FactoryGirl.create(:instance_map,:min_level => 10,:max_level => 20,:gold=>10000,:profession => 'witch')
            #@map2 = FactoryGirl.create(:instance_map,:min_level => 5,:max_level => 150,:gold=>20000)
            get :index, {:role_id => @role.id}
            assigns(:maps).count.should eq 0
        end
    end
end