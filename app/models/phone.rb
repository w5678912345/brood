class Phone < ActiveRecord::Base
 CODES = Api::CODES
   attr_accessible :id,:phone_machine_id,:no,:enabled,:last_active_at,:accounts_count,:can_bind
   self.primary_key=:no
   belongs_to :phone_machine
   has_many :accounts
   @@MAX_COOLDOWN = 3.minute
   scope :cooldown,where("last_active_at < ?",Time.now - @@MAX_COOLDOWN)

   def cooldown?
   		Time.now - self.last_active_at > @@MAX_COOLDOWN
   end

   def api_bind opts
   		account = Account.find_by_no(opts[:id])
   		return CODES[:not_find_account] unless account
   		account.update_attributes(:phone_id=>self.no)
         self.increment(:accounts_count,1)
         self.can_bind = false if self.accounts_count == 5
   		return 1 if self.save
   end

   def find_or_create_by_no no
   		phone = Phone.find_by_no(no)
   		phone = Phone.create(:no=>no) unless phone
   		return phone
   end

end
