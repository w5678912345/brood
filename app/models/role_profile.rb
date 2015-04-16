class RoleProfile < ActiveRecord::Base
  attr_accessible :data, :name, :roles_count, :version, :remark
  has_many :roles

  def set_roles_count
    RoleProfile.update_counters(self.id,:roles_count=> (self.roles.count - self.roles_count))
  end

  def self.reset_roles_count
    RoleProfile.all.each do |r|
      r.set_roles_count
    end
    return nil
  end
end
