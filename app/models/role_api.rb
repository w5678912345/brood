module RoleApi
	CODES = Api::CODES

  #
  def api_online opts
    return CODES[:role_have_online] if self.online
    return CODES[:role_has_closed] if self.close
    # get computer
    computer = Computer.find_by_auth_key(opts[:ckey])
    return CODES[:not_find_computer] unless computer
    # get ip
    ip = Ip.find_by_value(opts[:ip])
    if ip
      return CODES[:ip_used] if ip.use_count >= Setting.ip_max_use_count
    else
      ip = Ip.create(:value => opts[:ip]) 
    end
    self.transaction do
      computer.update_attributes(:roles_count=>computer.roles_count+1) 
      ip.update_attributes(:use_count=>ip.use_count+1)
      Note.create(:role_id=>self.id,:computer_id=>computer.id,:ip=>ip.value,:api_name=>"online")
      return 1 if self.update_attributes(:online=>true,:computer_id=>computer.id,:ip=>ip.value)
    end
  end

  #
  def api_offline opts
    ip = Ip.find_by_value(opts[:ip] || self.ip)
    ip = Ip.create(:value => opts[:ip]) unless ip
    self.transaction do
       return CODES[:role_not_online] unless self.online
       self.computer.update_attributes(:roles_count=>self.computer.roles_count-1) if self.computer
       ip.update_attributes(:use_count=>ip.use_count-1) if ip.use_count > 0
       Note.create(:role_id=>self.id,:computer_id=>self.computer_id,:ip=>ip.value,:api_name=>"offline")
       return 1 if self.update_attributes(:online=>false,:computer_id=>0,:ip=>nil)
    end
  end

  #
  def api_sync opts
     self.role_index = opts[:role_index] if opts[:role_index]
     self.server = opts[:server] if opts[:server]
     self.level = opts[:level] if opts[:level]
     self.vit_power = opts[:vit_power] if opts[:vit_power]
     self.gold = opts[:gold] if opts[:gold]
     #...
     self.transaction do
      #Note.create(:role_id=>self.id,:computer_id=>self.computer_id,:ip=>opts[:ip],:api_name=>"sync")
      return 1 if self.save
     end
  end

  def api_close opts
     self.transaction do
      self.close = true
      self.close_hours = opts[:h].to_i
      self.closed_at = Time.now
      self.reopen_at = Time.now.ago(self.close_hours.hours)
      Note.create(:role_id=>self.id,:ip=>opts[:ip],:api_name=>"close")
      return 1 if self.save
   end
  end

	def api_note opts
		ip = Ip.find_by_value(opts[:ip] || self.ip)
    ip = Ip.create(:value => opts[:ip]) unless ip
		self.transaction do
			return 1 if Note.create(:role_id=>self.id,:computer_id=>self.computer_id,:ip=>ip.value,:api_name=>"",:api_code=>opts[:code])
		end
	end


	def pay	opts
		ip = Ip.find_by_value(opts[:ip] || self.ip)
    ip = Ip.create(:value => opts[:ip]) unless ip
		self.transaction do
			note = Note.create(:role_id=>self.id,:computer_id=>self.computer_id,:ip=>ip.value,:api_name=>"pay")
			payment = Payment.new(:role_id=>self.id,:gold => opts[:gold],:balance => opts[:balance],:remark => opts[:remark],:note_id => note.id,:pay_type=>opts[:pay_type])	
			return CODES[:not_valid_pay] unless payment.valid? # validate not pass
			payment.total = self.total_pay + payment.balance+ payment.gold	
			self.update_attributes(:gold => payment.balance)
			
			return 1 if  payment.save
		end
	end

  def api_open opts
    self.transaction do

      return 1 if self.save
    end
  end
end
