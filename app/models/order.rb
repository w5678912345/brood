# encoding: utf-8
class Order < ActiveRecord::Base
    Btns = { "finish"=>"结束工单"}
    attr_accessible :phone_no, :account_no,:trigger_event, :pulled, :pulled_at, :finished, :finished_at, :result, :msg 
    attr_accessible :sms

	belongs_to :phone, :class_name => 'Phone', :foreign_key => 'phone_no',:primary_key => 'no'

	belongs_to :account, :class_name => 'Account', :foreign_key => 'account_no', :primary_key => 'no'

	default_scope order("id desc")

	def self.search opts
		orders = Order.includes(:phone)
		orders = orders.where("account_no =? ",opts[:account]) unless opts[:account].blank?
		orders = orders.where("phone_no =? ",opts[:phone]) unless opts[:phone].blank?
		orders = orders.where("trigger_event =? ",opts[:event]) unless opts[:event].blank?
		orders = orders.where("result =?",opts[:result]) unless opts[:result].blank?
		orders = orders.where("msg like ?","%#{opts[:msg]}%") unless opts[:msg].blank?
		orders = orders.where("date(created_at)=?",opts[:created_at]) unless opts[:created_at].blank?
		orders = orders.where("finished =? ",opts[:finished].to_i) unless opts[:finished].blank?
		return orders
	end

	def self.auto_finish
	  last_at = Time.now.ago(30.minutes).strftime("%Y-%m-%d %H:%M:%S")
      orders = Order.where(:finished=>false).where("updated_at < '#{last_at}'")
      orders.update_all(:finished=>true,:finished_at=>Time.now,:updated_at=>Time.now,:result=>"timeout",:msg=>"auto")
	end


end
