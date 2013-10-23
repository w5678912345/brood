# encoding: utf-8
class AddNormalAtToAccounts < ActiveRecord::Migration
  def change
  	add_column  :accounts,	:normal_at, :datetime # 恢复正常的时间
  end
end
