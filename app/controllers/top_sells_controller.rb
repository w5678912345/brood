# encoding: utf-8
class TopSellsController < ApplicationController  
  def index
    @top_sells = TopSell.all
  end
  def new
    @top_sell = TopSell.new
    @servers = Server.all.map &:name
  end
  def create
  end

  def show
  end
  def edit
    @top_sell = TopSell.find_by_id(params[:id])
  end
end
