class DirectGoldAgentsController < ApplicationController
  # GET /direct_gold_agents
  # GET /direct_gold_agents.json
  def index
    @direct_gold_agents = DirectGoldAgent.order(:server_id).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @direct_gold_agents }
    end
  end

  # GET /direct_gold_agents/1
  # GET /direct_gold_agents/1.json
  def show
    @direct_gold_agent = DirectGoldAgent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @direct_gold_agent }
    end
  end

  # GET /direct_gold_agents/new
  # GET /direct_gold_agents/new.json
  def new
    @direct_gold_agent = DirectGoldAgent.new
    @direct_gold_agent.enable = true
    @servers = Server.all.map &:name
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @direct_gold_agent }
    end
  end

  # GET /direct_gold_agents/1/edit
  def edit
    @servers = Server.all.map &:name
    @direct_gold_agent = DirectGoldAgent.find(params[:id])
  end

  # POST /direct_gold_agents
  # POST /direct_gold_agents.json
  def create
    @direct_gold_agent = DirectGoldAgent.new(params[:direct_gold_agent])

    respond_to do |format|
      if @direct_gold_agent.save
        format.html { redirect_to direct_gold_agents_path, notice: 'Direct gold agent was successfully created.' }
        format.json { render json: @direct_gold_agent, status: :created, location: @direct_gold_agent }
      else
        format.html { render action: "new" }
        format.json { render json: @direct_gold_agent.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /direct_gold_agents/1
  # PUT /direct_gold_agents/1.json
  def update
    @direct_gold_agent = DirectGoldAgent.find(params[:id])

    respond_to do |format|
      if @direct_gold_agent.update_attributes(params[:direct_gold_agent])
        format.html { redirect_to direct_gold_agents_path, notice: 'Direct gold agent was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @direct_gold_agent.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /direct_gold_agents/1
  # DELETE /direct_gold_agents/1.json
  def destroy
    @direct_gold_agent = DirectGoldAgent.find(params[:id])
    @direct_gold_agent.destroy

    respond_to do |format|
      format.html { redirect_to direct_gold_agents_url }
      format.json { head :no_content }
    end
  end
end
