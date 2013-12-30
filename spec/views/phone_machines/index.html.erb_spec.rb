require 'spec_helper'

describe "phone_machines/index" do
  before(:each) do
    assign(:phone_machines, [
      stub_model(PhoneMachine),
      stub_model(PhoneMachine)
    ])
  end

  it "renders a list of phone_machines" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
