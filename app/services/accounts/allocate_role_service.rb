module Accounts
  class AllocateRoleService
    def initialize account
      @account = account
    end
    def run all=false
      unless all
        roles_query = @account.roles.where("roles.status = 'normal' and roles.today_success = 0").
          reorder("is_helper desc").where("roles.level < ?",Setting.role_max_level)
        roles_query = roles_query.reorder("role_index").limit(Setting.account_start_roles_count)
      else
        roles_query = @account.roles
      end
      # 调度角色
      roles = roles_query.all
      roles_query.update_all(:online => true)
      roles
    end
  end
end