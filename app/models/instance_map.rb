class InstanceMap < ActiveRecord::Base
  attr_accessible :enter_count, :death_limit, :enabled, :gold, :max_level, :min_level, :name, :remark, :safety_limit,:key,:ishell
  has_many :role_sessions
  scope :level_scope, lambda{|role_level|where("min_level <= ?",role_level).where("max_level >= ? ",role_level).where(:enabled=>true).order("gold desc")}
  scope :ishell_scope, where(:ishell=>true)
  scope :safety_scope, where("enter_count < safety_limit")
  scope :death_scope,  where("enter_count >= safety_limit and enter_count < death_limit")
  
  # def self.include_role_count
  #     joins(
  #      %{
  #        LEFT OUTER JOIN (
  #          SELECT b.instance_map_id, COUNT(*) role_count
  #          FROM   role_sessions b
  #          GROUP BY b.instance_map_id
  #        ) a ON a.instance_map_id = instance_maps.id
  #      }
  #     ).select("instance_maps.*, a.role_count")
  # end

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


  def self.find_by_role role

    map = role.role_session.instance_map if role.role_session
    
    return map if map 

    level = role.level
    
    maps = InstanceMap.level_scope(level)
    if role.ishell
      map = maps.safety_scope.ishell_scope.first
      map = maps.death_scope.ishell_scope.first unless map
    end

    map = maps.safety_scope.first unless map
    map = maps.death_scope.first unless map

    return map
  end

  #def self.find_by__role


  def self.reset_enter_count
    InstanceMap.all.each do |map|
      map.update_attributes(:enter_count=>map.role_sessions.count) 
    end
    return nil
  end

end
