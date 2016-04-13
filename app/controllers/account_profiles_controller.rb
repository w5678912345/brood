class AccountProfilesController < ApplicationController
  # GET /account_profiles
  # GET /account_profiles.json
  def index
    @account_profiles = AccountProfile.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @account_profiles }
    end
  end

  # GET /account_profiles/1
  # GET /account_profiles/1.json
  def show
    @account_profile = AccountProfile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @account_profile }
    end
  end

  # GET /account_profiles/new
  # GET /account_profiles/new.json
  def new
    @account_profile = AccountProfile.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @account_profile }
    end
  end

  # GET /account_profiles/1/edit
  def edit
    @account_profile = AccountProfile.find(params[:id])
  end

  # POST /account_profiles
  # POST /account_profiles.json
  def create
    @account_profile = AccountProfile.new(params[:account_profile])

    respond_to do |format|
      if @account_profile.save
        format.html { redirect_to @account_profile, notice: 'Account profile was successfully created.' }
        format.json { render json: @account_profile, status: :created, location: @account_profile }
      else
        format.html { render action: "new" }
        format.json { render json: @account_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /account_profiles/1
  # PUT /account_profiles/1.json
  def update
    @account_profile = AccountProfile.find(params[:id])

    respond_to do |format|
      if @account_profile.update_attributes(params[:account_profile])
        format.html { redirect_to @account_profile, notice: 'Account profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @account_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account_profiles/1
  # DELETE /account_profiles/1.json
  def destroy
    @account_profile = AccountProfile.find(params[:id])
    @account_profile.destroy

    respond_to do |format|
      format.html { redirect_to account_profiles_url }
      format.json { head :no_content }
    end
  end
end
