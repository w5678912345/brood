# encoding: utf-8
class ComputersController < ApplicationController



	load_and_authorize_resource :class => "Computer"

  before_filter :require_tasks,:only=>[:index,:checked,:unchecked]
  
  def index
    
    @computers = Computer.includes(:user)
    #@computers = @computers.where("server = '' or server is NULL") if params[:server] == "null"
    @computers = @computers.where(:server=>params[:server]) unless params[:server].blank? || params[:server] == "null"
    @computers = @computers.where(:version=>params[:version]) unless params[:version].blank?  
    @computers = @computers.where(:id => params[:id]) unless params[:id].blank?
    @computers = @computers.where(:checked => params[:checked]) unless params[:checked].blank?
    @computers = @computers.where("hostname like ?","%#{params[:hostname]}%") unless params[:hostname].blank?
    @computers = @computers.where("auth_key like ?","%#{params[:ckey]}%") unless params[:ckey].blank? 
    per_page = params[:per_page].blank? ? 20 : params[:per_page].to_i
  	@computers = @computers.order("hostname desc").paginate(:page => params[:page], :per_page => per_page)
  end

  def home

  end



	def checked
		@computers = Computer.where(:checked => true).paginate(:page => params[:page], :per_page => 20)
		render :action => "index"
	end
	
	def unchecked
		@computers = Computer.where(:checked => false).paginate(:page => params[:page], :per_page => 20)
		render :action => "index"	
	end
	
	def check
		ids = params[:ids]
    checked = params[:checked].to_i
    return redirect_to computers_path unless ids
    if checked == 2
      session[:rids] = nil
      session[:cids] = ids
      return redirect_to pre_task_path(params[:task_id])
    end
    
    @computers = Computer.where(:id => ids)
    @computers.where(:roles_count => 0).destroy_all if checked == -1
    @computers.update_all(:checked => params[:checked],:check_user_id=>current_user.id,:checked_at => Time.now) if checked == 1 || checked ==0 

			# ids.each do |id|
			# 	computer = Computer.find_by_id(id)
			# 	computer.update_attributes(:checked => params[:checked],:check_user_id=>current_user.id,:checked_at => Time.now) if computer
			# end

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
    #params[:server] = params[:server].blank? ? nil : params[:server]
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
    @notes = @computer.notes.paginate(:page => params[:page], :per_page => 15) if @computer
  end

  def roles
    @computer = Computer.find_by_id(params[:id])
    @roles = @computer.roles.paginate(:page => params[:page], :per_page => 10) if @computer
  end

  def logs
    # AWS::S3::DEFAULT_HOST.replace ""

    @computer = Computer.find_by_id(params[:id])
    @s3_url = 'https://s3-ap-northeast-1.amazonaws.com/ccnt.tokyo/'
    s3 = AWS::S3.new(:s3_endpoint=>"s3-ap-northeast-1.amazonaws.com")
    bucket = s3.buckets['ccnt.tokyo']
    @log_path = "update/tianyi/cn/logs/#{@computer.auth_key}"
    #@log_path = "update/tianyi/cn/logs/A70C-73A3-7B8F-EC6D-178C-C87E-6586-0B5D"
    
    @objects = bucket.objects.with_prefix(@log_path).collect(&:key).sort.reverse
  end

  private 
  def require_tasks
    @tasks = Task.where(:sup_id => 0)
  end



end
