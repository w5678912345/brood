class AccountStatusesController < ApplicationController

  # GET /account_statuses
  # GET /account_statuses.json
  def index
    @account_statuses = AccountStatus.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @account_statuses }
    end
  end

  # GET /account_statuses/1
  # GET /account_statuses/1.json
  def show
    @account_status = AccountStatus.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @account_status }
    end
  end

  # GET /account_statuses/new
  # GET /account_statuses/new.json
  def new
    @account_status = AccountStatus.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @account_status }
    end
  end

  # GET /account_statuses/1/edit
  def edit
    @account_status = AccountStatus.find(params[:id])
  end

  # POST /account_statuses
  # POST /account_statuses.json
  def create
    @account_status = AccountStatus.new(params[:account_status])

    respond_to do |format|
      if @account_status.save
        format.html { redirect_to account_statuses_path, notice: 'Account status was successfully created.' }
        format.json { render json: @account_status, status: :created, location: @account_status }
      else
        format.html { render action: "new" }
        format.json { render json: @account_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /account_statuses/1
  # PUT /account_statuses/1.json
  def update
    @account_status = AccountStatus.find(params[:id])

    respond_to do |format|
      if @account_status.update_attributes(params[:account_status])
        format.html { redirect_to account_statuses_path, notice: 'Account status was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @account_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account_statuses/1
  # DELETE /account_statuses/1.json
  def destroy
    @account_status = AccountStatus.find(params[:id])
    @account_status.destroy

    respond_to do |format|
      format.html { redirect_to account_statuses_url }
      format.json { head :no_content }
    end
  end


end
