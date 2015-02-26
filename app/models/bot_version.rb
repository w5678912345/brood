class BotVersion < ActiveRecord::Base
  self.primary_key = :version
  attr_accessible :game_versions, :version
end
