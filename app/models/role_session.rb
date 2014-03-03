class RoleSession < ActiveRecord::Base
  attr_accessible :computer_id, :connection_times, :exchanged_gold, :live_at, :role_id, :start_exp, :start_gold, :start_level, :task, :used_gold, :ip
  belongs_to :role
  belongs_to :computer  
  belongs_to :instance_map
end
