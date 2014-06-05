class InstanceMap < ActiveRecord::Base
  attr_accessible :enter_count, :death_limit, :enabled, :gold, :max_level, :min_level, :name, :remark, :safety_limit,:key,:ishell
  has_many :role_sessions
  scope :level_scope,lambda{|role_level|where("min_level <= ?",role_level).where("max_level >= ? ",role_level).where(:enabled=>true).order("gold desc")}
  scope :safety_scope, where("enter_count < safety_limit")
  scope :death_scope,  where("enter_count >= safety_limit and enter_count < death_limit")
  
  def self.include_role_count
      joins(
       %{
         LEFT OUTER JOIN (
           SELECT b.instance_map_id, COUNT(*) role_count
           FROM   role_sessions b
           GROUP BY b.instance_map_id
         ) a ON a.instance_map_id = instance_maps.id
       }
      ).select("instance_maps.*, a.role_count")
  end

  def self.get_valid_one(level)
    level_maps = InstanceMap.level_scope(level)
    @map = nil
    level_maps.each do |m|
      if m.safe_count?
        @map = m
        break;
      end
    end

    if @map.nil?
      level_maps.each do |m|
        if not m.Full?
          @map = m
          break;
        end
      end
    end
    @map
  end

  def safe_count?
  	role_sessions.count < safety_limit
  end
  def Full?
    not (role_sessions.count < death_limit)
  end
end
