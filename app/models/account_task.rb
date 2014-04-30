# encoding: utf-8
class AccountTask < ActiveRecord::Base
   attr_accessible :account, :task, :event, :status, :result
end
