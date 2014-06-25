class InstanceMapsController < ApplicationController
  # GET /instance_maps
  # GET /instance_maps.json
  def index
    @instance_maps = initialize_grid(InstanceMap.include_role_count,:order=>"min_level")

    respond_to do |format|
      format.html { render "wice_index"}# index.html.erb
      format.json { render json: @instance_maps }
    end
  end

  # GET /instance_maps/1
  # GET /instance_maps/1.json
  def show
    @instance_map = InstanceMap.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @instance_map }
    end
  end

  # GET /instance_maps/new
  # GET /instance_maps/new.json
  def new
    @instance_map = InstanceMap.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @instance_map }
    end
  end

  # GET /instance_maps/1/edit
  def edit
    @instance_map = InstanceMap.find(params[:id])
  end

  # POST /instance_maps
  # POST /instance_maps.json
  def create
    @instance_map = InstanceMap.new(params[:instance_map])

    respond_to do |format|
      if @instance_map.save
        format.html { redirect_to @instance_map, notice: 'Instance map was successfully created.' }
        format.json { render json: @instance_map, status: :created, location: @instance_map }
      else
        format.html { render action: "new" }
        format.json { render json: @instance_map.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /instance_maps/1
  # PUT /instance_maps/1.json
  def update
    @instance_map = InstanceMap.find(params[:id])

    respond_to do |format|
      if @instance_map.update_attributes(params[:instance_map])
        format.html { redirect_to @instance_map, notice: 'Instance map was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @instance_map.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /instance_maps/1
  # DELETE /instance_maps/1.json
  def destroy
    @instance_map = InstanceMap.find(params[:id])
    @instance_map.destroy

    respond_to do |format|
      format.html { redirect_to instance_maps_url }
      format.json { head :no_content }
    end
  end

  def level
    
  end

end
