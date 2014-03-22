require 'spec_helper'
describe Api::OrdersController do
  it "can pull order" do
    c = FactoryGirl.create :computer 
    phone1 = FactoryGirl.create :phone
    get :sub, {:phone_id=>phone1.no,:trigger_event=>"qq_register",:sms=>'test',:target_no => '10086'}
    assigns(:order).should_not eq nil
    Order.count.should eq 1
  end
end
