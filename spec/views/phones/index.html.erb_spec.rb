require 'spec_helper'

describe "phones/index" do
  before(:each) do
    assign(:phones, [
      stub_model(Phone),
      stub_model(Phone)
    ])
  end

  it "renders a list of phones" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
