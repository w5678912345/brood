class RoleProfilesController < ApplicationController
  # GET /role_profiles
  # GET /role_profiles.json
  def index
    @role_profiles = RoleProfile.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @role_profiles }
    end
  end

  # GET /role_profiles/1
  # GET /role_profiles/1.json
  def show
    @role_profile = RoleProfile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @role_profile }
    end
  end

  # GET /role_profiles/new
  # GET /role_profiles/new.json
  def new
    @role_profile = RoleProfile.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @role_profile }
    end
  end

  # GET /role_profiles/1/edit
  def edit
    @role_profile = RoleProfile.find(params[:id])
  end

  # POST /role_profiles
  # POST /role_profiles.json
  def create
    @role_profile = RoleProfile.new(params[:role_profile])

    respond_to do |format|
      if @role_profile.save
        format.html { redirect_to @role_profile, notice: 'Role profile was successfully created.' }
        format.json { render json: @role_profile, status: :created, location: @role_profile }
      else
        format.html { render action: "new" }
        format.json { render json: @role_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /role_profiles/1
  # PUT /role_profiles/1.json
  def update
    @role_profile = RoleProfile.find(params[:id])

    respond_to do |format|
      if @role_profile.update_attributes(params[:role_profile])
        format.html { redirect_to @role_profile, notice: 'Role profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @role_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /role_profiles/1
  # DELETE /role_profiles/1.json
  def destroy
    @role_profile = RoleProfile.find(params[:id])
    @role_profile.destroy

    respond_to do |format|
      format.html { redirect_to role_profiles_url }
      format.json { head :no_content }
    end
  end
end
