require 'spec_helper'

describe PhoneMachine do
  it "PhoneMachine create" do
		pm = FactoryGirl.create(:phone_machine)
		pm.phones << FactoryGirl.create(:phone)
		pm.phones << FactoryGirl.create(:phone)
		pm.phones.count.should eq 2  	
  end
end
