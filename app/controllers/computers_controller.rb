# encoding: utf-8
class ComputersController < ApplicationController

  load_and_authorize_resource :class => "Computer"

  before_filter :require_tasks,:only=>[:index,:checked,:unchecked]
  
  def index
  
    @computers = Computer.where(:status=>1)
    #@computers = @computers.where("server = '' or server is NULL") if params[:server] == "null"
    @computers = @computers.where(:server=>params[:server]) unless params[:server].blank? #|| params[:server] == "null"
    @computers = @computers.no_server_scope if params[:no_server].to_i == 1
    @computers = @computers.where(:version=>params[:version]) unless params[:version].blank?  
    @computers = @computers.where(:id => params[:id]) unless params[:id].blank?
    @computers = @computers.where(:checked => params[:checked]) unless params[:checked].blank?
    @computers = @computers.where(:group => params[:group]) unless params[:group].blank?
    #
    unless params[:started].blank?
        @computers = params[:started].to_i == 1 ? @computers.started_scope : @computers.stopped_scope
    end
    unless params[:accounts_count].blank?
      tmp = params[:accounts_count].split("-")
      @computers = tmp.length == 2 ? @computers.where("accounts_count >= ? and accounts_count <= ?",tmp[0].to_i,tmp[1].to_i) : @computers.where(:accounts_count => params[:accounts_count])
    end
    unless params[:start_count].blank?
      tmp = params[:start_count].split("-")
      @computers = tmp.length == 2 ? @computers.where("online_accounts_count >= ? and online_accounts_count <= ?",tmp[0],tmp[1]) : @computers.where(:online_accounts_count=>tmp[0].to_i)
    end

    @computers = @computers.where(:status => params[:status].to_i) unless params[:status].blank?
    
    @computers = @computers.where("date(created_at) =?",params["date(created_at)"]) unless params["date(created_at)"].blank?
    @computers = @computers.where("hostname like ?","%#{params[:hostname]}%") unless params[:hostname].blank?
    @computers = @computers.where("auth_key like ?","%#{params[:ckey]}%") unless params[:ckey].blank? 
    @sum_accounts_count = @computers.sum(:accounts_count)
    params[:per_page] = params[:per_page].blank? ? 20 : params[:per_page].to_i
    params[:per_page] = @computers.count unless params[:all].blank?
  	@computers = @computers.order("hostname desc").paginate(:page => params[:page], :per_page => params[:per_page])

  end


  def update_accounts_count
    Computer.reset_accounts_count
    redirect_to computers_path
  end




	def checked
	 @ids = params[:ids]
   @do = params[:do]
   if @do == "bind_accounts"
     @unbind_accnouts_count =  Account.waiting_bind_scope.count 
   elsif @do == "task"
     @tasks = Task.sup_scope
   end

  end

  def do_checked
    @ids = params[:ids]
    @do = params[:do]
    @computers = Computer.where("id in (?)",@ids)
    #
    if @do == "pass"
      @computers.update_all(:checked=>true,:checked_at => Time.now)
      flash[:msg] = "通过了#{@computers.length}台机器"
    elsif @do == "refuse"
      @computers.update_all(:checked=>false,:checked_at => Time.now)
      flash[:msg] = "拒绝了#{@computers.length}台机器"
    elsif @do == "bind_accounts"
      @computers.each do |computer|
          computer.auto_bind_accounts({:status=>params[:status],:ip=>request.remote_ip,:msg=>"click",:avg=>params[:avg].to_i})
      end
      flash[:msg] = "为#{@computers.length}台机器，分配了账号"
    elsif @do == "task"
      @task = Task.find_by_id(params[:task_id])
      @ids.each do |cid|
        task = @task.new_by_computer cid,current_user.id
        task.save
      end
      flash[:msg] = "#{@computers.length}台机器，执行了远程任务 #{@task.name}"
    elsif @do == "clear_bind_accounts"
      @computers.each do |computer|
        computer.clear_bind_accounts(opts={:ip=>request.remote_ip,:msg=>"click",:bind=>params[:bind]})
      end
      flash[:msg] = "#{@computers.length}台机器，清空了绑定账号"
    elsif @do == "auto_binding_account"
      i = @computers.update_all(:auto_binding=>params[:auto_binding].to_i)
      flash[:msg] = "#{i}台机器设置了自动绑定账号"
    elsif @do == "set_group"
      i = @computers.update_all(:group => params[:group])
      flash[:msg] = "#{i}台机器设置了分组"
    end

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
    #
    if checked == 3
      @computers.each do |computer|
          computer.auto_bind_accounts
      end
    end
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
    @accounts = @computer.accounts.joins(:roles).reorder("accounts.session_id desc").order("roles.level desc").uniq()
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

  def online_roles
     @computer = Computer.find_by_id(params[:id])
     @roles = Role.where(:online=>true).where(:computer_id=>@computer.id).paginate(:page => params[:page], :per_page => 10)
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

  def alogs
     @computer = Computer.find_by_id(params[:id])
     prefix = "games/tianyi/cn/logs/8D90-03D8-C139-AC42-FC91-AF9E-B5C7-CDC6"
     prefix = "games/tianyi/cn/logs/#{@computer.auth_key}"
     @objects = AliyunHelper.get_objects(prefix)
  end

  
  def enable
    @computer = Computer.find_by_id(params[:id])
    @computer.update_attributes(:status => 1) if @computer
    redirect_to role_path(@computer)
  end

  def group_count
    @cols = {"server"=>"服务器","version"=>"版本","date(created_at)"=>"注册日期","accounts_count"=>"绑定账户","checked"=>"审核状态","online_accounts_count"=>"在线账户","started"=>"计算机在线"}
    @col = params[:col] || "server"
    @records = Computer.where(:status=>1).select("count(id) as computers_count, #{@col} as col").group(@col).reorder("computers_count desc")
  end

  def discardforyears
    @records = Computer.joins("LEFT JOIN notes ON computers.id = notes.computer_id")
    @records = @records.where(:group=>params[:group]) unless params[:group].blank?
    @records = @records.select("
      date(notes.created_at) as date,
      COUNT(DISTINCT if(api_name='account_start',account,null)) as start_count,
      COUNT(DISTINCT if(api_name='discardforyears',account,null)) as discardforyears_count
    ").group("date(notes.created_at)").reorder("notes.created_at desc")
  end


  private 
  def require_tasks
    @tasks = Task.where(:sup_id => 0)
  end



end
