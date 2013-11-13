# encoding: utf-8
class DataNode < ActiveRecord::Base
  # attr_accessible :title, :body

   attr_accessible :computers, :accounts, :roles, :events, :opts

   def self.mark
   		records = Account.select("count(id) as accounts_count, status").group("status")
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
