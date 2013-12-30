require 'spec_helper'

describe "phone_machines/new" do
  before(:each) do
    assign(:phone_machine, stub_model(PhoneMachine).as_new_record)
  end

  it "renders new phone_machine form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", phone_machines_path, "post" do
    end
  end
end
