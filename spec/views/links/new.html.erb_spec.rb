require 'spec_helper'

describe "links/new" do
  before(:each) do
    assign(:link, stub_model(Link,
      :phone_no => "MyString",
      :event => "MyString",
      :status => "MyString"
    ).as_new_record)
  end

  it "renders new link form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", links_path, "post" do
      assert_select "input#link_phone_no[name=?]", "link[phone_no]"
      assert_select "input#link_event[name=?]", "link[event]"
      assert_select "input#link_status[name=?]", "link[status]"
    end
  end
end
