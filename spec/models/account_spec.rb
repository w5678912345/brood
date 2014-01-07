require 'spec_helper'

describe Account do
  it "account create" do
	account1 = FactoryGirl.create(:account)
  end
  it "online account create" do
  	a1 = FactoryGirl.create(:online_account)
  end
end
