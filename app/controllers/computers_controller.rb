# encoding: utf-8
class ComputersController < ApplicationController
  
  def index
  	@computers= Computer.paginate(:page => params[:page], :per_page => 15)
  end

  def home

  end

  def new
  	@computer = Computer.new
  end

  def create
  	@computer = Computer.new(params[:computer])
  	@computer.user= current_user
  	@computer.save
    redirect_to computers_path()
  end

  def edit
  	@computer = Computer.find(params[:id])
  end

  def update
    @computer = Computer.find(params[:id])
    @computer.update_attributes(params[:computer])
    redirect_to computers_path()
  end

  def show
  	@computer = Computer.find(params[:id])
  end

  def destroy
  	@computer = Computer.find(params[:id])
  	@computer.destroy
    redirect_to computers_path()
  end

  def notes
    @computer = Computer.find_by_id(params[:id])
    @notes = @computer.notes.paginate(:page => params[:page], :per_page => 10) if @computer
  end

  def roles
    @computer = Computer.find_by_id(params[:id])
    @roles = @computer.roles.paginate(:page => params[:page], :per_page => 10) if @computer
  end



end
