module DailyRecords
  class CreateService
    def run date
      begin_time = date.to_time.change :hour => 6
      end_time = begin_time + 1.day

      error_event_count = AccountSession.select("finished_status as status,count(id) as num").
      where(started_status: 'normal').group("status").where("created_at between ? and ?",begin_time,end_time)

      error_event_count = Hash[error_event_count.map{|r|[r.status,r.num]}]

      DailyRecord.create do |r|
      r.date = date
      r.account_start_count = AccountSession.where("finished = false and created_at between ? and ?",begin_time,end_time).count
      r.role_start_count = HistoryRoleSession.where("created_at between ? and ?",begin_time,end_time).count
      r.success_role_count = Role.where("today_success = true").count
      r.consumed_vit_power_sum = r.success_role_count*156 - Role.where("today_success = false").select("sum(vit_power)as sum").first.sum
      r.role_online_hours = HistoryRoleSession.where("created_at between ? and ?",begin_time,end_time).select("sum(begin_at - end_at)")
      r.gold
      r.trade_gold
      r.bslocked_count
      r.discardforyears_count
      r.discardfordays_count
      r.exception_count
      r.recycle
      r.locked
      end
    end
  end
end