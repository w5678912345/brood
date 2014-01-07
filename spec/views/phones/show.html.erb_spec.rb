require 'spec_helper'

describe "phones/show" do
  before(:each) do
    @phone = assign(:phone, stub_model(Phone))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
