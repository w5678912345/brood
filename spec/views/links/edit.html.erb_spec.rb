require 'spec_helper'

describe "links/edit" do
  before(:each) do
    @link = assign(:link, stub_model(Link,
      :phone_no => "MyString",
      :event => "MyString",
      :status => "MyString"
    ))
  end

  it "renders the edit link form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", link_path(@link), "post" do
      assert_select "input#link_phone_no[name=?]", "link[phone_no]"
      assert_select "input#link_event[name=?]", "link[event]"
      assert_select "input#link_status[name=?]", "link[status]"
    end
  end
end
