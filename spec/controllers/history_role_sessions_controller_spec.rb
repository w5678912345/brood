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

describe HistoryRoleSessionsController do

  # This should return the minimal set of attributes required to create a valid
  # HistoryRoleSession. As you add validations to HistoryRoleSession, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { FactoryGirl.attributes_for :history_role_session}

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # HistoryRoleSessionsController. Be sure to keep this updated too.
  let(:valid_session) { {} }
  login_admin
  describe "GET index" do
    it "assigns all history_role_sessions as @history_role_sessions" do
      history_role_session = HistoryRoleSession.create! valid_attributes
      get :index, {}#, valid_session
      assigns(:history_role_sessions).should eq([history_role_session])
    end
  end

  describe "GET show" do
    it "assigns the requested history_role_session as @history_role_session" do
      history_role_session = HistoryRoleSession.create! valid_attributes
      get :show, {:id => history_role_session.to_param}#, valid_session
      assigns(:history_role_session).should eq(history_role_session)
    end
  end

  describe "GET new" do
    it "assigns a new history_role_session as @history_role_session" do
      get :new, {}#, valid_session
      assigns(:history_role_session).should be_a_new(HistoryRoleSession)
    end
  end

  describe "GET edit" do
    it "assigns the requested history_role_session as @history_role_session" do
      history_role_session = HistoryRoleSession.create! valid_attributes
      get :edit, {:id => history_role_session.to_param}#, valid_session
      assigns(:history_role_session).should eq(history_role_session)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new HistoryRoleSession" do
        expect {
          post :create, {:history_role_session => valid_attributes}#, valid_session
        }.to change(HistoryRoleSession, :count).by(1)
      end

      it "assigns a newly created history_role_session as @history_role_session" do
        post :create, {:history_role_session => valid_attributes}#, valid_session
        assigns(:history_role_session).should be_a(HistoryRoleSession)
        assigns(:history_role_session).should be_persisted
      end

      it "redirects to the created history_role_session" do
        post :create, {:history_role_session => valid_attributes}#, valid_session
        response.should redirect_to(HistoryRoleSession.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved history_role_session as @history_role_session" do
        # Trigger the behavior that occurs when invalid params are submitted
        HistoryRoleSession.any_instance.stub(:save).and_return(false)
        post :create, {:history_role_session => { "id" => "invalid value" }}#, valid_session
        assigns(:history_role_session).should be_a_new(HistoryRoleSession)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        HistoryRoleSession.any_instance.stub(:save).and_return(false)
        post :create, {:history_role_session => { "id" => "invalid value" }}#, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested history_role_session" do
        history_role_session = HistoryRoleSession.create! valid_attributes
        # Assuming there are no other history_role_sessions in the database, this
        # specifies that the HistoryRoleSession created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        HistoryRoleSession.any_instance.should_receive(:update_attributes).with({ "id" => "1" })
        put :update, {:id => history_role_session.to_param, :history_role_session => { "id" => "1" }}#, valid_session
      end

      it "assigns the requested history_role_session as @history_role_session" do
        history_role_session = HistoryRoleSession.create! valid_attributes
        put :update, {:id => history_role_session.to_param, :history_role_session => valid_attributes}#, valid_session
        assigns(:history_role_session).should eq(history_role_session)
      end

      it "redirects to the history_role_session" do
        history_role_session = HistoryRoleSession.create! valid_attributes
        put :update, {:id => history_role_session.to_param, :history_role_session => valid_attributes}#, valid_session
        response.should redirect_to(history_role_session)
      end
    end

    describe "with invalid params" do
      it "assigns the history_role_session as @history_role_session" do
        history_role_session = HistoryRoleSession.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        HistoryRoleSession.any_instance.stub(:save).and_return(false)
        put :update, {:id => history_role_session.to_param, :history_role_session => { "id" => "invalid value" }}#, valid_session
        assigns(:history_role_session).should eq(history_role_session)
      end

      it "re-renders the 'edit' template" do
        history_role_session = HistoryRoleSession.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        HistoryRoleSession.any_instance.stub(:save).and_return(false)
        put :update, {:id => history_role_session.to_param, :history_role_session => { "id" => "invalid value" }}#, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested history_role_session" do
      history_role_session = HistoryRoleSession.create! valid_attributes
      expect {
        delete :destroy, {:id => history_role_session.to_param}#, valid_session
      }.to change(HistoryRoleSession, :count).by(-1)
    end

    it "redirects to the history_role_sessions list" do
      history_role_session = HistoryRoleSession.create! valid_attributes
      delete :destroy, {:id => history_role_session.to_param}#, valid_session
      response.should redirect_to(history_role_sessions_url)
    end
  end

end
