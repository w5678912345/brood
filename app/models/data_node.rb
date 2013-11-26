# encoding: utf-8
class DataNode < ActiveRecord::Base
  # attr_accessible :title, :body

   attr_accessible :computers, :accounts, :roles, :events, :opts

    scope :date_scope,lambda{|start_date,end_date|where(created_at: start_date.at_beginning_of_day..end_date.end_of_day)}

   def self.mark
   		records = Account.select("count(id) as accounts_count, status").reorder("status").group("status")
   		h = {}
   		records.each do |record|
   			h[record.status] = record.accounts_count
   		end
   		DataNode.create(:accounts => h.to_s)
   end

   #
   def accounts_data
   		return eval(self.accounts)
   end

end
