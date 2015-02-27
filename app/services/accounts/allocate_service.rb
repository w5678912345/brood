module Accounts
  class AllocateService
    def initialize computer,ip
      @computer = computer
      @ip = ip
    end
    def run
      account = get_valid_account
      return account if account
      auto_bind_account
      nil
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
  end
end