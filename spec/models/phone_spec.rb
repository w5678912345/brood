require 'spec_helper'

describe Phone do
  it "get can use phone" do
  	time_active1 = Time.now - 1.minute
  	time_active2 = Time.now - 10.minute

	phone1 = FactoryGirl.create(:phone,:last_active_at => time_active1)
	phone2 = FactoryGirl.create(:phone,:last_active_at => time_active2)
	phone1.cooldown?.should be_false
	phone2.cooldown?.should be_true
	Phone.count.should eq 2
	Phone.cooldown.count.should eq 1
  end
end
