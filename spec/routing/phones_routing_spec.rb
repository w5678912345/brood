require "spec_helper"

describe PhonesController do
  describe "routing" do

    it "routes to #index" do
      get("/phones").should route_to("phones#index")
    end

    it "routes to #new" do
      get("/phones/new").should route_to("phones#new")
    end

    it "routes to #show" do
      get("/phones/1").should route_to("phones#show", :id => "1")
    end

    it "routes to #edit" do
      get("/phones/1/edit").should route_to("phones#edit", :id => "1")
    end

    it "routes to #create" do
      post("/phones").should route_to("phones#create")
    end

    it "routes to #update" do
      put("/phones/1").should route_to("phones#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/phones/1").should route_to("phones#destroy", :id => "1")
    end

  end
end
