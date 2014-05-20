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
			@phone1 = FactoryGirl.create(:phone,:no => "13212341234",:phone_machine => @old_machine)
			@phone2 = FactoryGirl.create(:phone,:no => "13212341235")
			expect {
          		post :bind_phones, {:format => "json",:name => "PhoneMachine2",:password => "12345678",
          			:phones => "13212341234,13212341235,13212341236,13212341237"}
        	}.to change(Phone, :count).by(2)
        	Phone.find("13212341234").phone_machine.should eq @machine
        	Phone.find("13212341235").phone_machine.should eq @machine
        	Phone.find("13212341236").phone_machine.should eq @machine
        	Phone.find("13212341237").phone_machine.should eq @machine
        end
        it "bind to none phone_machine" do
        	expect {
          		post :bind_phones, {:format => "json",:name => "PhoneMachine1",:password => "12345678",
          			:phones => "13212341234,13213241239,13212341236,13212341237"}
        	}.to change(Phone, :count).by(4)
        	PhoneMachine.count.should eq 1
        end
	end
	describe "machine online" do
		it "all online" do
			@machine1 = FactoryGirl.create(:phone_machine,:name => "PhoneMachine1")
			@machine2 = FactoryGirl.create(:phone_machine,:name => "PhoneMachine2")
			@phone1 = FactoryGirl.create(:phone,:no => "13212341234",:enabled => false,:phone_machine => @machine1)
			@phone2 = FactoryGirl.create(:phone,:no => "13212341235",:enabled => false,:phone_machine => @machine2)
			post :online, {:format => 'json',:names =>  "#{@machine1.name},#{@machine2.name}"}
			Phone.where(:enabled => true).count.should eq 2
		end
		it "auto disable other phones" do
			@machine1 = FactoryGirl.create(:phone_machine,:name => "PhoneMachine1")
			@machine2 = FactoryGirl.create(:phone_machine,:name => "PhoneMachine2")
			@phone1 = FactoryGirl.create(:phone,:no => "13212341234",:enabled => true,:phone_machine => @machine1)
			@phone2 = FactoryGirl.create(:phone,:no => "13212341235",:enabled => true,:phone_machine => @machine2)
			post :online, {:format => 'json',:names =>  "#{@machine1.name}",:computer => "computer1"}
			Phone.where(:enabled => true).count.should eq 1		
			Phone.find("13212341235").enabled.should eq false
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
			a1 = FactoryGirl.create(:account,:phone => phone1,:status => 'bslocked')

			#每个账号只能处理5次
			a20 = FactoryGirl.create(:online_account,:phone => phone1,:status => 'bslocked',:phone_event_count => 5)
			
			a2 = FactoryGirl.create(:online_account,:phone => phone1,:status => 'bslocked',:phone_event_count => 3)
			a21 = FactoryGirl.create(:online_account,:phone => phone2,:status => 'bslocked',:phone_event_count => 2)
			a3 = FactoryGirl.create(:online_account,:phone => phone3,:status => 'bslocked')
			get :can_unlock_accounts, {:name => phone_machine.name}
			
			assigns(:accounts).count.should eq(2)

			assigns(:accounts).should eq([a21,a2])
    	end
	end
end
