require 'spec_helper'
describe Api::PhonesController do
  it "Can get register phone" do
    p = FactoryGirl.create :phone
    get :qq_register
    assigns(:phone).should eq p
  end
  it "can't get disable register phone" do 
    p = FactoryGirl.create :phone
    FactoryGirl.create :link ,:phone_no => p.no, :event => "qq_register", :status => "disable"
    get :qq_register
    assigns(:phone).should eq nil
  end
end
