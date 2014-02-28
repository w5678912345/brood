class InstanceMap < ActiveRecord::Base
  attr_accessible :death_limit, :enabled, :enter_count, :gold, :max_level, :min_level, :name, :remark, :safety_limit

  scope :level_scope,lambda{|role_level|where("min_level <= ?",role_level).where("max_level >= ? ",role_level).where(:enabled=>true).order("gold desc")}
  scope :safety_scope, where("enter_count < safety_limit")
  scope :death_scope,  where("enter_count >= safety_limit and enter_count < death_limit")
end
