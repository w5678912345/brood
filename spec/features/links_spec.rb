require 'spec_helper'

describe "Links" do
  before do
    sign_in
  end
  describe "GET /links" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      visit links_path
      expect(page).to have_content('退出')
      #expect(page).to have_content('Phone no')
    end
  end
end
