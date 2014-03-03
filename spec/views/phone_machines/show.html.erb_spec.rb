require 'spec_helper'

describe "phone_machines/show" do
  before(:each) do
    @phone_machine = assign(:phone_machine, stub_model(PhoneMachine))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
