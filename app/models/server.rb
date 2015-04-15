# encoding: utf-8
class Server < ActiveRecord::Base
  # attr_accessible :title, :body
  acts_as_taggable # Alias for acts_as_taggable_on :tags
  acts_as_taggable_on :group

   attr_accessible :name, :role_str,:roles_count,:computers_count,:goods,:price
   attr_accessible :gold_price, :gold_unit, :allowed_new,:point

   validates :name, presence: true

   def roles
   	 return [] if self.role_str.blank?
   	 return self.role_str.split(",")
   end

   

end
