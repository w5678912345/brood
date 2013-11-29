# encoding: utf-8
class Server < ActiveRecord::Base
  # attr_accessible :title, :body

   attr_accessible :name, :role_str,:roles_count,:computers_count,:goods,:price
   attr_accessible :gold_price, :gold_unit

   validates :name, presence: true

   def roles
   	 return [] if self.role_str.blank?
   	 return self.role_str.split(",")
   end

   

end
