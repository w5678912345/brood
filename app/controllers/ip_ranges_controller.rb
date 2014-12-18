class IpRangesController < ApplicationController
  # GET /ip_ranges
  # GET /ip_ranges.json
  def index
    @ip_ranges = initialize_grid(IpRange)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ip_ranges }
    end
  end

  # GET /ip_ranges/1
  # GET /ip_ranges/1.json
  def show
    @ip_range = IpRange.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ip_range }
    end
  end

  # GET /ip_ranges/new
  # GET /ip_ranges/new.json
  def new
    @ip_range = IpRange.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ip_range }
    end
  end

  # GET /ip_ranges/1/edit
  def edit
    @ip_range = IpRange.find(params[:id])
  end

  # POST /ip_ranges
  # POST /ip_ranges.json
  def create
    @ip_range = IpRange.new(params[:ip_range])

    respond_to do |format|
      if @ip_range.save
        format.html { redirect_to ip_ranges_path, notice: 'Ip range was successfully created.' }
        format.json { render json: @ip_range, status: :created, location: @ip_range }
      else
        format.html { render action: "new" }
        format.json { render json: @ip_range.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /ip_ranges/1
  # PUT /ip_ranges/1.json
  def update
    @ip_range = IpRange.find(params[:id])

    respond_to do |format|
      if @ip_range.update_attributes(params[:ip_range])
        format.html { redirect_to ip_ranges_path, notice: 'Ip range was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @ip_range.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ip_ranges/1
  # DELETE /ip_ranges/1.json
  def destroy
    @ip_range = IpRange.find(params[:id])
    @ip_range.destroy

    respond_to do |format|
      format.html { redirect_to ip_ranges_url }
      format.json { head :no_content }
    end
  end
end
