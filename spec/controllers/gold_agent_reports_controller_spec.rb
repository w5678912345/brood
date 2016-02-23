require 'spec_helper'

describe GoldAgentReportsController do

  describe "GET 'today'" do
    it "returns http success" do
      get 'today'
      response.should be_success
    end
  end

end
