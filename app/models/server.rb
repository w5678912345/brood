# encoding: utf-8
class Server < ActiveRecord::Base
  # attr_accessible :title, :body
  acts_as_taggable # Alias for acts_as_taggable_on :tags
  acts_as_taggable_on :group

  attr_accessible :name, :role_str,:roles_count,:computers_count,:goods,:price,:group_list
  attr_accessible :gold_price,:gold_recv_count, :gold_unit, :allowed_new,:point,:enable_transfer_gold,:pay_type

  validates :name, presence: true

  has_many :top_sells, :foreign_key => 'server_name',:primary_key => 'name'
  accepts_nested_attributes_for :top_sells, :allow_destroy => :true,  
    :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }  
  attr_accessible :top_sells_attributes
  def self.update_today_gold_price
    Server.all.each do |s|
      prices = GoldPriceRecord.select("avg(max_price) as price, avg(max_count) as max_count").
      where("created_at > ? and server_id = ?",Date.today.beginning_of_day,s.id)
      s.update_attributes :gold_price => prices.first.price,:gold_recv_count if prices.first
    end
  end

  def roles
    return [] if self.top_sells.blank?
    return self.top_sells.map &:role_name
  end
  def self.convert_from_old_data
    Server.all.each do |s|
      s.roles.each do |r|
        TopSell.create server_name: s.name,role_name: r,goods: s.goods,price: s.price
      end
    end
  end
  def self.set_role_seller
    Server.all.each do |s|
      names = Account.where(:gold_agent_level => 2,server: s.name).select("distinct(gold_agent_name) as gold_agent_name").map &:gold_agent_name
      Role.joins(:qq_account).where("accounts.server = ? and name in(?)",s.name,names).update_all(is_seller: true)
    end
  end
end
