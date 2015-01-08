class TicketRecord < ActiveRecord::Base
  attr_accessible :account, :gold, :msg, :points, :role_id,:role_name, :server

end
