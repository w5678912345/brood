class Phone < ActiveRecord::Base
   attr_accessible :id,:phone_machine_id,:no,:enabled,:last_active_at
   self.primary_key=:no
   belongs_to :phone_machine
   has_many :accounts
   @@MAX_COOLDOWN = 3.minute
   scope :cooldown,where("last_active_at < ?",Time.now - @@MAX_COOLDOWN)

   def cooldown?
   		Time.now - self.last_active_at > @@MAX_COOLDOWN
   end
end
