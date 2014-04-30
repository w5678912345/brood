# encoding: utf-8
class AccountTask < ActiveRecord::Base
   attr_accessible :account, :task, :event, :status, :result,:msg


   def self.auto_finish
  	last_at = Time.now.ago(60.minutes).strftime("%Y-%m-%d %H:%M:%S")
  	tasks = AccountTask.where("status = ?","doing").where("updated_at <= ? ",last_at)
  	tasks.update_all(:updated_at=>Time.now,:status=>"finished",:msg=>"timeout")
  end


end
