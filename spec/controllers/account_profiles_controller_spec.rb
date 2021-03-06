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

describe AccountProfilesController do

  # This should return the minimal set of attributes required to create a valid
  # AccountProfile. As you add validations to AccountProfile, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "enable" => "false" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # AccountProfilesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all account_profiles as @account_profiles" do
      account_profile = AccountProfile.create! valid_attributes
      get :index, {}, valid_session
      assigns(:account_profiles).should eq([account_profile])
    end
  end

  describe "GET show" do
    it "assigns the requested account_profile as @account_profile" do
      account_profile = AccountProfile.create! valid_attributes
      get :show, {:id => account_profile.to_param}, valid_session
      assigns(:account_profile).should eq(account_profile)
    end
  end

  describe "GET new" do
    it "assigns a new account_profile as @account_profile" do
      get :new, {}, valid_session
      assigns(:account_profile).should be_a_new(AccountProfile)
    end
  end

  describe "GET edit" do
    it "assigns the requested account_profile as @account_profile" do
      account_profile = AccountProfile.create! valid_attributes
      get :edit, {:id => account_profile.to_param}, valid_session
      assigns(:account_profile).should eq(account_profile)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new AccountProfile" do
        expect {
          post :create, {:account_profile => valid_attributes}, valid_session
        }.to change(AccountProfile, :count).by(1)
      end

      it "assigns a newly created account_profile as @account_profile" do
        post :create, {:account_profile => valid_attributes}, valid_session
        assigns(:account_profile).should be_a(AccountProfile)
        assigns(:account_profile).should be_persisted
      end

      it "redirects to the created account_profile" do
        post :create, {:account_profile => valid_attributes}, valid_session
        response.should redirect_to(AccountProfile.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved account_profile as @account_profile" do
        # Trigger the behavior that occurs when invalid params are submitted
        AccountProfile.any_instance.stub(:save).and_return(false)
        post :create, {:account_profile => { "enable" => "invalid value" }}, valid_session
        assigns(:account_profile).should be_a_new(AccountProfile)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        AccountProfile.any_instance.stub(:save).and_return(false)
        post :create, {:account_profile => { "enable" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested account_profile" do
        account_profile = AccountProfile.create! valid_attributes
        # Assuming there are no other account_profiles in the database, this
        # specifies that the AccountProfile created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        AccountProfile.any_instance.should_receive(:update_attributes).with({ "enable" => "false" })
        put :update, {:id => account_profile.to_param, :account_profile => { "enable" => "false" }}, valid_session
      end

      it "assigns the requested account_profile as @account_profile" do
        account_profile = AccountProfile.create! valid_attributes
        put :update, {:id => account_profile.to_param, :account_profile => valid_attributes}, valid_session
        assigns(:account_profile).should eq(account_profile)
      end

      it "redirects to the account_profile" do
        account_profile = AccountProfile.create! valid_attributes
        put :update, {:id => account_profile.to_param, :account_profile => valid_attributes}, valid_session
        response.should redirect_to(account_profile)
      end
    end

    describe "with invalid params" do
      it "assigns the account_profile as @account_profile" do
        account_profile = AccountProfile.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        AccountProfile.any_instance.stub(:save).and_return(false)
        put :update, {:id => account_profile.to_param, :account_profile => { "enable" => "invalid value" }}, valid_session
        assigns(:account_profile).should eq(account_profile)
      end

      it "re-renders the 'edit' template" do
        account_profile = AccountProfile.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        AccountProfile.any_instance.stub(:save).and_return(false)
        put :update, {:id => account_profile.to_param, :account_profile => { "enable" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested account_profile" do
      account_profile = AccountProfile.create! valid_attributes
      expect {
        delete :destroy, {:id => account_profile.to_param}, valid_session
      }.to change(AccountProfile, :count).by(-1)
    end

    it "redirects to the account_profiles list" do
      account_profile = AccountProfile.create! valid_attributes
      delete :destroy, {:id => account_profile.to_param}, valid_session
      response.should redirect_to(account_profiles_url)
    end
  end

end
