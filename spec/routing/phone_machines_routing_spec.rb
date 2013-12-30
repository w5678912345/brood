require "spec_helper"

describe PhoneMachinesController do
  describe "routing" do

    it "routes to #index" do
      get("/phone_machines").should route_to("phone_machines#index")
    end

    it "routes to #new" do
      get("/phone_machines/new").should route_to("phone_machines#new")
    end

    it "routes to #show" do
      get("/phone_machines/1").should route_to("phone_machines#show", :id => "1")
    end

    it "routes to #edit" do
      get("/phone_machines/1/edit").should route_to("phone_machines#edit", :id => "1")
    end

    it "routes to #create" do
      post("/phone_machines").should route_to("phone_machines#create")
    end

    it "routes to #update" do
      put("/phone_machines/1").should route_to("phone_machines#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/phone_machines/1").should route_to("phone_machines#destroy", :id => "1")
    end

  end
end
