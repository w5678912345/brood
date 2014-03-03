require 'spec_helper'

describe "phone_machines/edit" do
  before(:each) do
    @phone_machine = assign(:phone_machine, stub_model(PhoneMachine))
  end

  it "renders the edit phone_machine form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", phone_machine_path(@phone_machine), "post" do
    end
  end
end
