class DailyRecord < ActiveRecord::Base
  attr_accessible :account_start_count, :bslocked_count, :consumed_vit_power_sum, :date, :discardfordays_count, :discardforyears_count, :exception_count, :gold, :locked, :recycle, :role_online_hours, :role_start_count, :success_role_count, :trade_gold
  self.primary_key=:date
end
