require 'spec_helper'

describe "PhoneMachines" do
  before do
    sign_in
  end
  describe "GET /phone_machines" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      visit phone_machines_path
      expect(page).to have_content('退出')
      expect(page).to have_content('Listing phone_machines')
    end
  end
end
