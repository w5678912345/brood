class GoldAgentAllocationsController < ApplicationController

  # GET /gold_agent_allocations/new
  # GET /gold_agent_allocations/new.json
  def new
    @servers = Server.all.map &:name
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @gold_agent_allocation }
    end
  end
  # POST /gold_agent_allocations
  # POST /gold_agent_allocations.json
  def create
    server = params[:server] || 'all'
    @allocate = Accounts::AllocateAgentsService.new(server)
    @allocate.run
  end
end
