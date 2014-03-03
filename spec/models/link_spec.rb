require 'spec_helper'

describe Link do
	it "can create with phone_no and event" do
		attrs = FactoryGirl.attributes_for :link
		Link.create! attrs
		Link.count.should eq 1
	end
	it "can search" do 
		l1 = FactoryGirl.create :link
		l2 = FactoryGirl.create :link,:event => "other"
		Link.count.should eq 2
		r = Link.search({:event =>"bslock"})
		r.count.should eq 1
	end
end
