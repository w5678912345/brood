# encoding: utf-8
class PhoneMachinesController < ApplicationController
  # GET /phone_machines
  # GET /phone_machines.json
  def index
    @phone_machines = PhoneMachine.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @phone_machines }
    end
  end

  # GET /phone_machines/1
  # GET /phone_machines/1.json
  def show
    @phone_machine = PhoneMachine.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @phone_machine }
    end
  end

  # GET /phone_machines/new
  # GET /phone_machines/new.json
  def new
    @phone_machine = PhoneMachine.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @phone_machine }
    end
  end

  # GET /phone_machines/1/edit
  def edit
    @phone_machine = PhoneMachine.find(params[:id])
  end

  # POST /phone_machines
  # POST /phone_machines.json
  def create
    @phone_machine = PhoneMachine.new(params[:phone_machine])

    respond_to do |format|
      if @phone_machine.save
        format.html { redirect_to @phone_machine, notice: 'Phone machine was successfully created.' }
        format.json { render json: @phone_machine, status: :created, location: @phone_machine }
      else
        format.html { render action: "new" }
        format.json { render json: @phone_machine.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /phone_machines/1
  # PUT /phone_machines/1.json
  def update
    @phone_machine = PhoneMachine.find(params[:id])

    respond_to do |format|
      if @phone_machine.update_attributes(params[:phone_machine])
        format.html { redirect_to @phone_machine, notice: 'Phone machine was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @phone_machine.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /phone_machines/1
  # DELETE /phone_machines/1.json
  def destroy
    @phone_machine = PhoneMachine.find(params[:id])
    @phone_machine.destroy

    respond_to do |format|
      format.html { redirect_to phone_machines_url }
      format.json { head :no_content }
    end
  end

  def can_unlock_accounts
    @phone_machine = PhoneMachine.find(params[:id])
    @accounts = Account.online_scope.joins(:phone).where("phone_machine_id = ? and accounts.status = ?",params[:id],'bslocked')
  end
end
