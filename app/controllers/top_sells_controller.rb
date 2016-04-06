# encoding: utf-8
class TopSellsController < ApplicationController  
  def index
    @top_sells = TopSell.order("server_name").all
  end
  def new
    @top_sell = TopSell.new
    @servers = Server.all.map &:name
  end
  def create
    @top_sell = TopSell.new(params[:top_sell])

    respond_to do |format|
      if @top_sell.save
        format.html { redirect_to @top_sell, notice: 'top_sell was successfully created.' }
        format.json { render json: @top_sell, status: :created, location: @top_sell }
      else
        format.html { render action: "new" }
        format.json { render json: @top_sell.errors, status: :unprocessable_entity }
      end
    end

  end

  def update
    @top_sell = TopSell.find(params[:id])

    respond_to do |format|
      if @top_sell.update_attributes(params[:top_sell])
        format.html { redirect_to top_sells_path, notice: 'top_sell was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @top_sell.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @top_sell = TopSell.find(params[:id])
  end

  def edit
    @top_sell = TopSell.find_by_id(params[:id])
  end

  def destroy
    @top_sell = TopSell.find(params[:id])
    @top_sell.destroy

    respond_to do |format|
      format.html { redirect_to top_sells_url }
      format.json { head :no_content }
    end
  end
end
