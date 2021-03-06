require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe InstanceMapsController do

  # This should return the minimal set of attributes required to create a valid
  # InstanceMap. As you add validations to InstanceMap, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { FactoryGirl.attributes_for(:instance_map) }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # InstanceMapsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  login_admin

  describe "GET index" do
    it "assigns all instance_maps as @instance_maps" do
      instance_map = InstanceMap.create! valid_attributes
      InstanceMap.count.should eq 1
      get :index, {}#, valid_session
      #assigns(:instance_maps).should eq([instance_map])
    end
  end

  describe "GET show" do
    it "assigns the requested instance_map as @instance_map" do
      instance_map = InstanceMap.create! valid_attributes
      get :show, {:id => instance_map.to_param} #, valid_session
      assigns(:instance_map).should eq(instance_map)
    end
  end

  describe "GET new" do
    it "assigns a new instance_map as @instance_map" do
      get :new, {}#, valid_session
      assigns(:instance_map).should be_a_new(InstanceMap)
    end
  end

  describe "GET edit" do
    it "assigns the requested instance_map as @instance_map" do
      instance_map = InstanceMap.create! valid_attributes
      get :edit, {:id => instance_map.to_param}#, valid_session
      assigns(:instance_map).should eq(instance_map)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new InstanceMap" do
        expect {
          post :create, {:instance_map => valid_attributes}#, valid_session
        }.to change(InstanceMap, :count).by(1)
      end

      it "assigns a newly created instance_map as @instance_map" do
        post :create, {:instance_map => valid_attributes}#, valid_session
        assigns(:instance_map).should be_a(InstanceMap)
        assigns(:instance_map).should be_persisted
      end

      it "redirects to the created instance_map" do
        post :create, {:instance_map => valid_attributes}#, valid_session
        response.should redirect_to(InstanceMap.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved instance_map as @instance_map" do
        # Trigger the behavior that occurs when invalid params are submitted
        InstanceMap.any_instance.stub(:save).and_return(false)
        post :create, {:instance_map => { "name" => "invalid value" }}#, valid_session
        assigns(:instance_map).should be_a_new(InstanceMap)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        InstanceMap.any_instance.stub(:save).and_return(false)
        post :create, {:instance_map => { "name" => "invalid value" }}#, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested instance_map" do
        instance_map = InstanceMap.create! valid_attributes
        # Assuming there are no other instance_maps in the database, this
        # specifies that the InstanceMap created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        InstanceMap.any_instance.should_receive(:update_attributes).with({ "name" => "MyString" })
        put :update, {:id => instance_map.to_param, :instance_map => { "name" => "MyString" }}#, valid_session
      end

      it "assigns the requested instance_map as @instance_map" do
        instance_map = InstanceMap.create! valid_attributes
        put :update, {:id => instance_map.to_param, :instance_map => valid_attributes}#, valid_session
        assigns(:instance_map).should eq(instance_map)
      end

      it "redirects to the instance_map" do
        instance_map = InstanceMap.create! valid_attributes
        put :update, {:id => instance_map.to_param, :instance_map => valid_attributes}#, valid_session
        response.should redirect_to(instance_map)
      end
    end

    describe "with invalid params" do
      it "assigns the instance_map as @instance_map" do
        instance_map = InstanceMap.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        InstanceMap.any_instance.stub(:save).and_return(false)
        put :update, {:id => instance_map.to_param, :instance_map => { "name" => "invalid value" }}#, valid_session
        assigns(:instance_map).should eq(instance_map)
      end

      it "re-renders the 'edit' template" do
        instance_map = InstanceMap.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        InstanceMap.any_instance.stub(:save).and_return(false)
        put :update, {:id => instance_map.to_param, :instance_map => { "name" => "invalid value" }}#, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested instance_map" do
      instance_map = InstanceMap.create! valid_attributes
      expect {
        delete :destroy, {:id => instance_map.to_param}#, valid_session
      }.to change(InstanceMap, :count).by(-1)
    end

    it "redirects to the instance_maps list" do
      instance_map = InstanceMap.create! valid_attributes
      delete :destroy, {:id => instance_map.to_param}#, valid_session
      response.should redirect_to(instance_maps_url)
    end
  end

end
