# encoding: utf-8
class Link < ActiveRecord::Base
  attr_accessible :event, :phone_no, :status,:updated_at,:enabled

  belongs_to :phone, :class_name => 'Phone', :foreign_key => 'phone_no',:primary_key => 'no'


  def self.get phone_no,event
  	link = Link.where(:phone_no=>phone_no,:event=>event).first
	  link = Link.create(:phone_no=>phone_no,:event=>event) unless link
    return link
  end

  def update_status status
  	self.update_attributes(:status=>status)
  end
  
  def self.auto_idle
  	last_at = Time.now.ago(60.minutes).strftime("%Y-%m-%d %H:%M:%S")
  	links = Link.where("status != ?","idle").where("updated_at <= ? ",last_at)
  	links.update_all(:updated_at=>Time.now,:status=>"idle")
  end


  def self.search(opts)
  	links = Link.where("id > 0 ")
  	links = links.where("phone_no = ?",opts[:no]) unless opts[:no].blank?
  	links = links.where("status = ?",opts[:status]) unless opts[:status].blank?
  	links = links.where("event =? ",opts[:event]) unless opts[:event].blank?
    links = links.where("date(created_at)=?",opts[:created_at]) unless opts[:created_at].blank?
  	return links
  end

end
