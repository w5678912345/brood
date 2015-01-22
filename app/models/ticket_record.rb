class TicketRecord < ActiveRecord::Base
  attr_accessible :account, :gold, :msg, :points, :role_id,:role_name, :server

  scope :time_scope,lambda{|start_time,end_time|where(created_at: start_time..end_time)}

  def self.server_data
  	ticket_records = {}
		records = TicketRecord.select("sum(gold - (gold%1000000)) as server_gold,sum(points) as server_points,server").group("server")
		records.each do |record|
			ticket_records[record.server] = [record.server_gold,record.server_points]
		end
	 return ticket_records
  end
end
