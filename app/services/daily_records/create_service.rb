module DailyRecords
  class CreateService
    def run date
      begin_time = date.to_time.change :hour => 6
      end_time = begin_time + 1.day

      error_event_count = AccountSession.select("finished_status as status,count(distinct(account_id)) as num").
      group("status").where(lived_at: begin_time..end_time).
      where(finished_status: ['discardforyears','discardfordays','bs_unlock_fail','recycle','exception','locked','disconnect'])

      error_event_count = Hash[error_event_count.map{|r|[r.status.to_sym,r.num]}]
      gold_price = GoldPriceRecord.select("avg(max_price) as price").where(created_at: begin_time..end_time).first


      DailyRecord.create do |r|
        r.date = date
        r.total_cashbox = Account.sum(:cashbox)+Role.sum(:gold)
        r.account_start_count = AccountSession.where(created_at: begin_time..end_time).count
        r.role_start_count = HistoryRoleSession.where(created_at: begin_time..end_time).count
        r.success_role_count = Role.where("today_success = true").count
        r.average_level = Role.where("today_success = true").average(:level)
        r.consumed_vit_power_sum = r.success_role_count*156 - Role.where("today_success = true").sum(:vit_power)
        r.consumed_vit_power_sum = 0 if r.consumed_vit_power_sum.nil? or r.consumed_vit_power_sum < 0
        r.role_online_hours = HistoryRoleSession.where(created_at: begin_time..end_time).sum("end_at - begin_at").to_i/3600000
        #HistoryRoleSession.where(created_at: begin_time..end_time).sum(:gold)
        r.gold = Payment.real_pay.where(created_at: begin_time..end_time).sum(:gold)
        r.trade_gold = Payment.time_scope(begin_time,end_time).sum(:gold)
        r.gold_price = gold_price.price if gold_price

        r.bslocked_count = error_event_count[:bs_unlock_fail] if error_event_count[:bs_unlock_fail]
        r.discardforyears_count = error_event_count[:discardforyears] if error_event_count[:discardforyears]
        r.discardfordays_count = error_event_count[:discardfordays] if error_event_count[:discardfordays]
        r.exception_count = error_event_count[:exception] if error_event_count[:exception]
        r.recycle_count = error_event_count[:recycle] if error_event_count[:recycle]
        r.locked_count = error_event_count[:locked] if error_event_count[:locked]
        r.dc_count =  error_event_count[:disconnect] if error_event_count[:disconnect]
      end
    end
  end
end