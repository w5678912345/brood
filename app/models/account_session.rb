class AccountSession < ActiveRecord::Base
  attr_accessible :finished, :finished_at, :finished_status, :remark, :started_at, :started_status
end
