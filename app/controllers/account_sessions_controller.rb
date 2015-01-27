class AccountSessionsController < ApplicationController
  # GET /account_sessions
  # GET /account_sessions.json
  def index
    @account_sessions = initialize_grid(AccountSession)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @account_sessions }
    end
  end

  # GET /account_sessions/1
  # GET /account_sessions/1.json
  def show
    @account_session = AccountSession.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @account_session }
    end
  end

  # GET /account_sessions/new
  # GET /account_sessions/new.json
  def new
    @account_session = AccountSession.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @account_session }
    end
  end

  # GET /account_sessions/1/edit
  def edit
    @account_session = AccountSession.find(params[:id])
  end

  # POST /account_sessions
  # POST /account_sessions.json
  def create
    @account_session = AccountSession.new(params[:account_session])

    respond_to do |format|
      if @account_session.save
        format.html { redirect_to @account_session, notice: 'Account session was successfully created.' }
        format.json { render json: @account_session, status: :created, location: @account_session }
      else
        format.html { render action: "new" }
        format.json { render json: @account_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /account_sessions/1
  # PUT /account_sessions/1.json
  def update
    @account_session = AccountSession.find(params[:id])

    respond_to do |format|
      if @account_session.update_attributes(params[:account_session])
        format.html { redirect_to @account_session, notice: 'Account session was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @account_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account_sessions/1
  # DELETE /account_sessions/1.json
  def destroy
    @account_session = AccountSession.find(params[:id])
    @account_session.destroy

    respond_to do |format|
      format.html { redirect_to account_sessions_url }
      format.json { head :no_content }
    end
  end
end
