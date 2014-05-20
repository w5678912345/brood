class IpFiltersController < ApplicationController
  # GET /ip_filters
  # GET /ip_filters.json
  def index
    @ip_filters = IpFilter.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ip_filters }
    end
  end

  # GET /ip_filters/1
  # GET /ip_filters/1.json
  def show
    @ip_filter = IpFilter.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ip_filter }
    end
  end

  # GET /ip_filters/new
  # GET /ip_filters/new.json
  def new
    @ip_filter = IpFilter.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ip_filter }
    end
  end

  # GET /ip_filters/1/edit
  def edit
    @ip_filter = IpFilter.find(params[:id])
  end

  # POST /ip_filters
  # POST /ip_filters.json
  def create
    @ip_filter = IpFilter.new(params[:ip_filter])

    respond_to do |format|
      if @ip_filter.save
        format.html { redirect_to @ip_filter, notice: 'Ip filter was successfully created.' }
        format.json { render json: @ip_filter, status: :created, location: @ip_filter }
      else
        format.html { render action: "new" }
        format.json { render json: @ip_filter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /ip_filters/1
  # PUT /ip_filters/1.json
  def update
    @ip_filter = IpFilter.find(params[:id])

    respond_to do |format|
      if @ip_filter.update_attributes(params[:ip_filter])
        format.html { redirect_to @ip_filter, notice: 'Ip filter was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @ip_filter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ip_filters/1
  # DELETE /ip_filters/1.json
  def destroy
    @ip_filter = IpFilter.find(params[:id])
    @ip_filter.destroy

    respond_to do |format|
      format.html { redirect_to ip_filters_url }
      format.json { head :no_content }
    end
  end
end
