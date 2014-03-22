require 'spec_helper'

describe "InstanceMaps" do
  before do
    sign_in
  end
  describe "GET /instance_maps" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      visit instance_maps_path
      expect(page).to have_content('退出')
    end
  end
end
