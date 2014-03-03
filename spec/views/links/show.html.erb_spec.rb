require 'spec_helper'

describe "links/show" do
  before(:each) do
    @link = assign(:link, stub_model(Link,
      :phone_no => "Phone No",
      :event => "Event",
      :status => "Status"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Phone No/)
    rendered.should match(/Event/)
    rendered.should match(/Status/)
  end
end
