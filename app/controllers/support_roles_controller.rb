class SupportRolesController < ApplicationController
  # GET /support_roles
  # GET /support_roles.json
  def index
    @support_roles =initialize_grid(SupportRole)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @support_roles }
    end
  end

  # GET /support_roles/1
  # GET /support_roles/1.json
  def show
    @support_role = SupportRole.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @support_role }
    end
  end

  # GET /support_roles/new
  # GET /support_roles/new.json
  def new
    @support_role = SupportRole.new
    @servers = Server.all
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @support_role }
    end
  end

  # GET /support_roles/1/edit
  def edit
    @support_role = SupportRole.find(params[:id])
    @servers = Server.all
  end

  # POST /support_roles
  # POST /support_roles.json
  def create
    @support_role = SupportRole.new(params[:support_role])

    respond_to do |format|
      if @support_role.save
        format.html { redirect_to support_roles_path, notice: 'Support role was successfully created.' }
        format.json { render json: @support_role, status: :created, location: @support_role }
      else
        format.html { render action: "new" }
        format.json { render json: @support_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /support_roles/1
  # PUT /support_roles/1.json
  def update
    @support_role = SupportRole.find(params[:id])

    respond_to do |format|
      if @support_role.update_attributes(params[:support_role])
        format.html { redirect_to @support_role, notice: 'Support role was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @support_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /support_roles/1
  # DELETE /support_roles/1.json
  def destroy
    @support_role = SupportRole.find(params[:id])
    @support_role.destroy

    respond_to do |format|
      format.html { redirect_to support_roles_url }
      format.json { head :no_content }
    end
  end
end
