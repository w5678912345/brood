module Accounts
  class StartService
    def initialize account
      @account = account
    end
    def run computer,ip
      @account.transaction do
        as = @account.create_account_session do |as|
          as.computer = computer
          as.ip = ip
          as.ip_c = get_ip_c ip
          as.started_status = @account.status
          as.lived_at = Time.now
        end
        @account.update_attributes(:last_start_ip=>ip,:last_start_at => Time.now,:session_id => as.id)
      end
    end
    def get_ip_c ip_str
      part = ip_str.split '.'
      part[0]+'.'+part[1]+'.'+part[2]+'.0'
    end

  end
end