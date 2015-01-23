class RoleProfile < ActiveRecord::Base
  attr_accessible :data, :name, :roles_count, :version
end
