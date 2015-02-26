class BotVersionsController < ApplicationController
  # GET /bot_versions
  # GET /bot_versions.json
  def index
    @bot_versions = BotVersion.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bot_versions }
    end
  end

  # GET /bot_versions/1
  # GET /bot_versions/1.json
  def show
    @bot_version = BotVersion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bot_version }
    end
  end

  # GET /bot_versions/new
  # GET /bot_versions/new.json
  def new
    @bot_version = BotVersion.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bot_version }
    end
  end

  # GET /bot_versions/1/edit
  def edit
    @bot_version = BotVersion.find(params[:id])
  end

  # POST /bot_versions
  # POST /bot_versions.json
  def create
    @bot_version = BotVersion.new(params[:bot_version])

    respond_to do |format|
      if @bot_version.save
        format.html { redirect_to @bot_version, notice: 'Bot version was successfully created.' }
        format.json { render json: @bot_version, status: :created, location: @bot_version }
      else
        format.html { render action: "new" }
        format.json { render json: @bot_version.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bot_versions/1
  # PUT /bot_versions/1.json
  def update
    @bot_version = BotVersion.find(params[:id])

    respond_to do |format|
      if @bot_version.update_attributes(params[:bot_version])
        format.html { redirect_to @bot_version, notice: 'Bot version was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @bot_version.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bot_versions/1
  # DELETE /bot_versions/1.json
  def destroy
    @bot_version = BotVersion.find(params[:id])
    @bot_version.destroy

    respond_to do |format|
      format.html { redirect_to bot_versions_url }
      format.json { head :no_content }
    end
  end
end
