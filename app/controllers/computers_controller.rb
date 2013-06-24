# encoding: utf-8
class ComputersController < ApplicationController

	load_and_authorize_resource :class => "Computer"
  
  def index
  	@computers= Computer.includes(:user).paginate(:page => params[:page], :per_page => 15)
  end

  def home

  end

	def checked
		@computers = Computer.where(:checked => true).paginate(:page => params[:page], :per_page => 15)
		render :action => "index"
	end
	
	def unchecked
		@computers = Computer.where(:checked => false).paginate(:page => params[:page], :per_page => 15)
		render :action => "index"	
	end
	
	def check
		ids = params[:ids]
		if ids
			ids.each do |id|
				computer = Computer.find_by_id(id)
				computer.update_attributes(:checked => params[:checked],:check_user_id=>current_user.id,:checked_at => Time.now) if computer
			end
		end
		redirect_to computers_path
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
  	@computer = Computer.find_by_id(params[:id])
		if @computer && @computer.roles_count ==0
			@computer.destroy
		end
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
