class InstanceMap < ActiveRecord::Base
  attr_accessible :enter_count,:profession, :death_limit, :enabled, :gold, :max_level, :min_level, :name, :remark, :safety_limit,:key,:ishell,:client_manual,:group
  has_many :role_sessions
  scope :level_scope, lambda{|role_level|where("min_level <= ?",role_level).where("max_level >= ? ",role_level).where(:enabled=>true).order("gold desc")}
  scope :ishell_scope, where(:ishell=>true)
  scope :safety_scope, where("enter_count < safety_limit")
  scope :death_scope,  where("enter_count >= safety_limit and enter_count < death_limit")
  scope :client_manual_scope, where("client_manual = false")
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
  	self.enter_count < safety_limit
  end
  def Full?
    not (self.enter_count < death_limit)
  end

  def self.find_by_role_session role_session
    role = role_session.role
    map = role_session.instance_map
    return map if map && role_session.start_level == role.level
  end


  def self.find_by_role role,opts={}
    find_by_role_imp(role,opts,role.profession) || find_by_role_imp(role,opts)
  end
  def self.find_by_role_imp role,opts={},profession = 'all'

    level = role.level
    
    maps = InstanceMap.level_scope(level).where(:profession => profession)
    maps = maps.where(:name => opts[:expect_map_name]) if opts[:expect_map_name].present?
    maps = maps.where("instance_maps.group not in (?)",opts[:exgroup]) if opts[:exgroup].present?
    maps = maps.client_manual_scope if opts[:expect_map_name].blank?
    if role.ishell && opts[:ishell].to_i == 1
      map = maps.safety_scope.ishell_scope.first
      map = maps.death_scope.ishell_scope.first unless map
    end

    map = maps.safety_scope.first unless map
    map = maps.death_scope.first unless map

    return map
  end



  def set_enter_count
    InstanceMap.update_counters(self.id,:enter_count=> (self.role_sessions.count - self.enter_count))
  end

  def self.reset_enter_count
    InstanceMap.all.each do |map|
      map.set_enter_count
    end
    return nil
  end

  # before_destroy do |map|
  #   map.role_sessions.update_all(:instance_map_id=>0)
  # end

end
