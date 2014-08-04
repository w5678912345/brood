class RoleSessionsController < ApplicationController
  # GET /role_sessions
  # GET /role_sessions.json
  def index
    @role_sessions = RoleSession.joins([:role]).includes(:instance_map).includes(:role => :computer)
    @role_sessions = @role_sessions.where("role_sessions.instance_map_id = ?",params[:map_id].to_i) unless params[:map_id].blank?
    @role_sessions = @role_sessions.select("role_sessions.*, roles.total")
    @role_sessions = initialize_grid(@role_sessions)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @role_sessions }
    end
  end

  # GET /role_sessions/1
  # GET /role_sessions/1.json
  def show
    @role_session = RoleSession.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @role_session }
    end
  end

  # GET /role_sessions/new
  # GET /role_sessions/new.json
  def new
    @role_session = RoleSession.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @role_session }
    end
  end

  # GET /role_sessions/1/edit
  def edit
    @role_session = RoleSession.find(params[:id])
  end

  # POST /role_sessions
  # POST /role_sessions.json
  def create
    @role_session = RoleSession.new(params[:role_session])

    respond_to do |format|
      if @role_session.save
        format.html { redirect_to @role_session, notice: 'Role session was successfully created.' }
        format.json { render json: @role_session, status: :created, location: @role_session }
      else
        format.html { render action: "new" }
        format.json { render json: @role_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /role_sessions/1
  # PUT /role_sessions/1.json
  def update
    @role_session = RoleSession.find(params[:id])

    respond_to do |format|
      if @role_session.update_attributes(params[:role_session])
        format.html { redirect_to @role_session, notice: 'Role session was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @role_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /role_sessions/1
  # DELETE /role_sessions/1.json
  def destroy
    @role_session = RoleSession.find(params[:id])
    @role_session.destroy

    respond_to do |format|
      format.html { redirect_to role_sessions_url }
      format.json { head :no_content }
    end
  end
end
