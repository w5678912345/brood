require 'spec_helper'

describe "links/index" do
  before(:each) do
    assign(:links, [
      stub_model(Link,
        :phone_no => "Phone No",
        :event => "Event",
        :status => "Status"
      ),
      stub_model(Link,
        :phone_no => "Phone No",
        :event => "Event",
        :status => "Status"
      )
    ])
  end

  it "renders a list of links" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Phone No".to_s, :count => 2
    assert_select "tr>td", :text => "Event".to_s, :count => 2
    assert_select "tr>td", :text => "Status".to_s, :count => 2
  end
end
