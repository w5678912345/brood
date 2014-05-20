class IpFilter < ActiveRecord::Base
  attr_accessible :enabled, :regex, :reverse
  def self.try(ip)
  	self.all.each do |f|
  		if f.reverse==true
  			return false if ip =~ Regexp.new(f.regex)
  		else
  			return false unless ip =~ Regexp.new(f.regex)
  		end
  	end
  	true
  end
end
