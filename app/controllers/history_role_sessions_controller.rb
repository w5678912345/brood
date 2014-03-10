class HistoryRoleSessionsController < ApplicationController
  # GET /history_role_sessions
  # GET /history_role_sessions.json
  def index
    @history_role_sessions = HistoryRoleSession.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @history_role_sessions }
    end
  end

  # GET /history_role_sessions/1
  # GET /history_role_sessions/1.json
  def show
    @history_role_session = HistoryRoleSession.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @history_role_session }
    end
  end

  # GET /history_role_sessions/new
  # GET /history_role_sessions/new.json
  def new
    @history_role_session = HistoryRoleSession.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @history_role_session }
    end
  end

  # GET /history_role_sessions/1/edit
  def edit
    @history_role_session = HistoryRoleSession.find(params[:id])
  end

  # POST /history_role_sessions
  # POST /history_role_sessions.json
  def create
    @history_role_session = HistoryRoleSession.new(params[:history_role_session])

    respond_to do |format|
      if @history_role_session.save
        format.html { redirect_to @history_role_session, notice: 'History role session was successfully created.' }
        format.json { render json: @history_role_session, status: :created, location: @history_role_session }
      else
        format.html { render action: "new" }
        format.json { render json: @history_role_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /history_role_sessions/1
  # PUT /history_role_sessions/1.json
  def update
    @history_role_session = HistoryRoleSession.find(params[:id])

    respond_to do |format|
      if @history_role_session.update_attributes(params[:history_role_session])
        format.html { redirect_to @history_role_session, notice: 'History role session was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @history_role_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /history_role_sessions/1
  # DELETE /history_role_sessions/1.json
  def destroy
    @history_role_session = HistoryRoleSession.find(params[:id])
    @history_role_session.destroy

    respond_to do |format|
      format.html { redirect_to history_role_sessions_url }
      format.json { head :no_content }
    end
  end
end
