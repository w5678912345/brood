module Accounts
  class StopService
    def initialize account_session
      @account_session = account_session
    end
    def run success,msg
      return 1 if @account_session.transaction do
        @account_session.role_session.stop(success) if @account_session.role_session
        @account_session.account.roles.update_all(:online => false)
        @account_session.account.update_attributes :today_success => success,:session_id => 0

        ip = Ip.find_or_create(@account_session.ip)
        ip.update_attributes(:cooling_time=>25.hours.from_now)

        @account_session.finished_status = @account_session.started_status if @account_session.finished_status.nil?
        @account_session.remark = msg if msg.present?
        @account_session.update_attributes :finished_at => Time.now,:finished => true
      end
    end
  end
end