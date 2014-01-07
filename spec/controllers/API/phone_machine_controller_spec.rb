require 'spec_helper'

describe Api::PhoneMachineController do
	describe "post create" do

		it "creates a new PhoneMachine" do
        	expect {
          		post :create, {:format => "json",:name => "PhoneMachine1",:password => "12345678"}
        	}.to change(PhoneMachine, :count).by(1)
      	end
	end
	describe "bind phones" do
		it "bind new phones" do
			@phone_machine = FactoryGirl.create(:phone_machine,:name => "PhoneMachine1")
       		expect {
          		post :bind_phones, {:format => "json",:name => "PhoneMachine1",:password => "12345678",
          			:phones => "13212341234,13213241239,13212341236,13212341237"}
        	}.to change(Phone, :count).by(4)
		end
		it "bind old phone" do
			@old_machine = FactoryGirl.create(:phone_machine,:name => "PhoneMachine1")
			@machine = FactoryGirl.create(:phone_machine,:name => "PhoneMachine2")
			@phone1 = FactoryGirl.create(:phone,:id => "13212341234",:phone_machine => @old_machine)
			@phone2 = FactoryGirl.create(:phone,:id => "13212341235")
			expect {
          		post :bind_phones, {:format => "json",:name => "PhoneMachine2",:password => "12345678",
          			:phones => "13212341234,13212341235,13212341236,13212341237"}
        	}.to change(Phone, :count).by(2)
        	Phone.find("13212341234").phone_machine.should eq @machine
        	Phone.find("13212341235").phone_machine.should eq @machine
        end
        it "bind to none phone_machine" do
        	expect {
          		post :bind_phones, {:format => "json",:name => "PhoneMachine1",:password => "12345678",
          			:phones => "13212341234,13213241239,13212341236,13212341237"}
        	}.to change(Phone, :count).by(0)
        end
	end

	describe "GET bslock" do
    	it "获取当前需要解bslock的账号" do
    		phone_machine = FactoryGirl.create(:phone_machine)
			phone_machine1 = FactoryGirl.create(:phone_machine)
			phone1 = FactoryGirl.create(:phone,:phone_machine => phone_machine)
			phone2 = FactoryGirl.create(:phone,:phone_machine => phone_machine)
			phone3 = FactoryGirl.create(:phone,:phone_machine => phone_machine1)
			a0 = FactoryGirl.create(:account)
			a1 = FactoryGirl.create(:account,:phone => phone1,:status => 'bs_unlock_fail')

			a20 = FactoryGirl.create(:online_account,:phone => phone1,:status => 'bs_unlock_fail',:phone_event_count => 5)
			
			a2 = FactoryGirl.create(:online_account,:phone => phone1,:status => 'bs_unlock_fail',:phone_event_count => 4)
			a21 = FactoryGirl.create(:online_account,:phone => phone2,:status => 'bs_unlock_fail')
			a3 = FactoryGirl.create(:online_account,:phone => phone3,:status => 'bs_unlock_fail')
			get :can_unlock_accounts, {:name => phone_machine.name}
			
			assigns(:accounts).count.should eq(2)

			#a21.phone_event_count += 1
			#a2.phone_event_count += 1
			#返回的账号是和上线顺序相反的，即session_id desc
			assigns(:accounts).should eq([a21,a2])
    	end
	end
end
