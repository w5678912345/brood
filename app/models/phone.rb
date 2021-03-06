# encoding: utf-8
class Phone < ActiveRecord::Base
 CODES = Api::CODES
 STATUS = ['idle','sent','busy']
 Btns = { "set_status"=>"修改状态","set_enabled"=>"设置是否可用"}
   attr_accessible :id,:iccid,:online,:phone_machine_id,:no,:enabled,:last_active_at,:accounts_count,:can_bind,:status,:sms_count,:today_sms_count,:can_unlock
   self.primary_key=:no
   belongs_to :phone_machine
   has_many :phone_tasks
   has_many :accounts
   has_many :orders, :class_name=>'Order',:foreign_key => 'phone_no', :primary_key => 'no'
   has_many :links, :class_name => 'Link', :foreign_key => 'phone_no', :primary_key => 'no'

   @@MAX_COOLDOWN = 3.minute
   scope :cooldown,where("last_active_at < ?",Time.now - @@MAX_COOLDOWN)

   scope :can_pull_scope, lambda{|machine_id| joins(:orders).where("phones.status = ?","idle").where("phones.phone_machine_id =?",machine_id).where("orders.finished=0").uniq().readonly(false)}


   def self.timeout
      Phone.where("last_active_at < ?",30.minutes.ago).update_all(:online => false)
   end

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

   def self.search opts
      phones = Phone.includes(:phone_machine)
      phones = phones.where("no =? ",opts[:no]) unless opts[:no].blank?
      phones = phones.where("status =? ",opts[:status]) unless opts[:status].blank?
      phones = phones.where("enabled =? ",opts[:enabled].to_i) unless opts[:enabled].blank?
      #phones = phones.where("online in (?)",opts[:grid][:f][:online]) if opts[:grid] and opts[:grid][:f] and opts[:grid][:f][:online]
      return phones
   end
   def get_filter_boolean_value f

   end
   before_create do |phone|
      phone.status = "idle"
   end

end
