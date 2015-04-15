# encoding: utf-8
class ComputersController < ApplicationController

  #load_and_authorize_resource :class => "Computer"

  before_filter :require_tasks,:only=>[:index,:checked,:unchecked,:show]
  
  def index
    
    @computers = Computer.where("id > 0 ").include_bind_account_count
    @computers = @computers.where(:status=>params[:status]) unless params[:status].blank?
    #@computers = @computers.where("server = '' or server is NULL") if params[:server] == "null"
    #@computers = @computers.where(:server=>params[:server]) unless params[:server].blank? #|| params[:server] == "null"
    @computers = @computers.where("server like ?","%#{params[:server]}%") unless params[:server].blank?
    @computers = @computers.no_server_scope if params[:no_server].to_i == 1
    @computers = @computers.where(:version=>params[:version]) unless params[:version].blank?  
    @computers = @computers.where(:id => params[:id]) unless params[:id].blank?
    @computers = @computers.where(:checked => params[:checked]) unless params[:checked].blank?
    @computers = @computers.where(:group => params[:group]) unless params[:group].blank?
    @computers = @computers.where(:auto_binding => params[:ab]) unless params[:ab].blank?
    @computers = @computers.where(:auto_unbind => params[:aunb]) unless params[:aunb].blank?
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
      if tmp.length == 2 
        @computers = @computers.include_online_account_count.where("online_account_count >= ? and online_account_count <= ?",tmp[0],tmp[1]) 
      elsif tmp[0].to_i == 0
        @computers = @computers.include_online_account_count.where('online_account_count is null')
      else
        @computers = @computers.include_online_account_count.where('online_account_count = ?',tmp[0].to_i)
      end
    end
    unless params[:client_count].blank?
      tmp = params[:client_count].split("-")
      @computers = tmp.length == 2 ? @computers.where("client_count >= ? and client_count <= ?",tmp[0].to_i,tmp[1].to_i) : @computers.where(:client_count=>tmp[0].to_i)      
    end

    @computers = @computers.where(:status => params[:status].to_i) unless params[:status].blank?
    
    @computers = @computers.where("date(created_at) =?",params["date(created_at)"]) unless params["date(created_at)"].blank?
    @computers = @computers.where("hostname like ?","%#{params[:hostname]}%") unless params[:hostname].blank?
    @computers = @computers.where("auth_key like ?","%#{params[:ckey]}%") unless params[:ckey].blank? 
    @sum_accounts_count = @computers.sum(:accounts_count)
    #params[:per_page] = params[:per_page].blank? ? 20 : params[:per_page].to_i
    #params[:per_page] = @computers.count unless params[:all].blank?
  	#@computers = @computers.order("hostname desc").paginate(:page => params[:page], :per_page => params[:per_page])
    params[:per_page] = params[:per_page].blank? ? 20 : params[:per_page].to_i
    params[:per_page] = @computers.count unless params[:all].blank?
    @computers = initialize_grid(@computers,:per_page => params[:per_page],:include => :account_sessions)
    @global_auto_unbind = Setting.auto_unbind?
    render "wice_index"

  end


  def update_accounts_count
    Computer.reset_accounts_count
    redirect_to computers_path
  end

  def run_anylize
    params[:date] = Date.yesterday.to_s if params[:date].nil?
    @computers = initialize_grid(Computer.include_day_finished_role_count(Date.parse(params[:date])))
  end


	def checked
    @ids = [] 
    @ids = params[:grid][:selected] || [] if params[:grid]
    @do = params[:do]
    case @do
    when "bind_accounts"
      @unbind_accnouts_count =  Account.waiting_bind_scope.count 
    when "task"
      @tasks = Task.sup_scope
    when "delete_all"
      Note.where(:computer_id => @ids).delete_all
      HistoryRoleSession.where(:computer_id => @ids).delete_all
      AccountSession.where(:computer_id => @ids).delete_all
      RoleSession.where(:computer_id => @ids).delete_all
      Account.where(:bind_computer_id => @ids).update_all(:bind_computer_id => 0)
      Computer.where(:id => @ids).delete_all
      redirect_to computers_path
    else
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
        computer.clear_bind_accounts(opts={:ip=>request.remote_ip,:msg=>"click",:bind=>params[:bind],:count=>params[:count],:status=>params[:status]})
      end
      flash[:msg] = "#{@computers.length}台机器，解绑了绑定账号"
    elsif @do == "auto_binding_account"
      i = @computers.update_all(:auto_binding=>params[:auto_binding].to_i)
      flash[:msg] = "#{i}台机器设置了自动绑定账号"
    elsif @do == "set_group"
      i = @computers.update_all(:group => params[:group])
      flash[:msg] = "#{i}台机器设置了分组"
    elsif @do == "set_status"
      i = @computers.update_all(:status => params[:status].to_i)
      flash[:msg] = "#{i}台机器设置了状态"
    elsif @do == "set_max_accounts"
      i = @computers.update_all(:max_accounts => params[:max_accounts].to_i)
      flash[:msg] = "#{i}台机器设置了最大账户数"
    elsif @do == "set_allowed_new"
      i = @computers.update_all(:allowed_new => params[:allowed_new].to_i)
      flash[:msg] = "#{i}台机器设置是否自动绑定新号"
    elsif @do == "set_client_count"
      client_count = params[:client_count].to_i
      max_accounts = client_count * Setting.client_role_count
      i = @computers.update_all(:client_count => client_count,:max_accounts => max_accounts) if client_count > 0
      flash[:msg] = "#{i}台机器修改了客户端数量"
    elsif @do == "get_log_file"
      at = params[:at] || Date.today.strftime("%y-%m-d%")
      file = params[:file]
      @computers.each do |computer|
          #args = "#{at}.log.txt"
          Task.create(:name=>"提取日志",:user_id => current_user.id,:args=>file,:command=>"get_log_file",:remark=>params[:remark],:computer_id=>computer.id,:sup_id=>-1)
      end
      flash[:msg] = "#{@computers.count}个机器,正在提取日志"
    elsif @do == "set_auto_unbind_account"
      i = @computers.update_all(:auto_unbind=>params[:auto_unbind].to_i)
      flash[:msg] = "#{i}台机器设置了自动解绑"
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

    @task = Task.sup_scope.where(:command => 'restart').first

    @accounts = initialize_grid(Account.where(:bind_computer_id => @computer.id),:per_page=>10)

    @account_sessions = initialize_grid(AccountSession.where(:computer_id => @computer.id),
      :order => 'account_sessions.id',
      :order_direction => 'desc')
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
