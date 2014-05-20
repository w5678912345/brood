require 'spec_helper'

describe IpFilter do
	it "can disable ip that not pass filter test" do
		FactoryGirl.create :ip_filter,:regex => "112\.121\..*"
		IpFilter.try("").should be false
		IpFilter.try("111.111.111.111").should be false
		IpFilter.try("112.123.111.111").should be false
		IpFilter.try("112.121.111.111").should be true
	end
	it "can disable ip that not pass all filter test" do
		#ip must pass (rule1 and rule2)

		FactoryGirl.create :ip_filter,:regex => "112\.121\..*",:reverse => true
		FactoryGirl.create :ip_filter,:regex => "1\.2\.3\..*",:reverse => true
		IpFilter.try("").should be false
		IpFilter.try("111.111.111.111").should be true
		IpFilter.try("112.123.111.111").should be true
		IpFilter.try("112.121.111.111").should be false
		IpFilter.try("1.2.3.111").should be false
	end
end
