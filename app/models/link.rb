# encoding: utf-8
class Link < ActiveRecord::Base
  attr_accessible :event, :phone_no, :status

  belongs_to :phone, :class_name => 'Phone', :foreign_key => 'phone_no',:primary_key => 'no'


  def self.get phone_no,event
  	link = Link.where(:phone_no=>phone_no,:event=>event).first
	link = Link.create(:phone_no=>self.phone_no,:event=>event) if link.nil?
  end

  def update_status status
  	self.update_attributes(:status=>status)
  end

end
