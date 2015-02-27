module Accounts
  class AllocateService
    def initialize computer,ip
      @computer = computer
      @ip = ip
    end
    def run all_role=false
      account = get_valid_account
      if account
        account_start account,all_role
      else
        auto_bind_account
        nil
      end
    end

    def get_valid_account
      role = Role.select(:account).joins(:qq_account).can_used.
        where("accounts.session_id = 0 and accounts.bind_computer_id = ? and accounts.normal_at <= ? and accounts.enabled = 1",@computer.id,Time.now).first
      role.qq_account if role
    end

    def auto_bind_account 
      @computer.auto_bind_accounts({:ip=>@ip,:msg=>"auto by start",:avg=>1})  if @computer.auto_binding
      #如果是重复发生的事件将不会记录
      if @computer.msg != 'not_find_account'
      # 记录事件
       Note.create(:computer_id=>@computer.id,:hostname=>@computer.hostname,:ip=>@ip,:server => @computer.server,
        :version => @computer.version,:api_name=>"not_find_account")     
      end
    end

    def account_start account,all_role
      account.transaction do
        as = account.create_account_session do |as|
          as.computer = @computer
          as.ip = @ip
          as.ip_c = get_ip_c @ip
          as.started_status = account.status
          as.lived_at = Time.now
        end
        account.update_attributes(:last_start_ip=>@ip,:last_start_at => Time.now,:session_id => as.id)
      end
      
      unless all_role
        roles_query = account.roles.waiting_scope.where("roles.level < ?",Setting.role_max_level)
        roles_query = roles_query.reorder("role_index").limit(Setting.account_start_roles_count)
      else
        roles_query = account.roles
      end
      # 调度角色
      roles = roles_query.all
      roles_query.update_all(:online => true)
      
      return {:account => account,:roles => roles}
    end

    def get_ip_c ip_str
      part = ip_str.split '.'
      part[0]+'.'+part[1]+'.'+part[2]+'.0'
    end

  end
end