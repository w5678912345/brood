module RoleApi
	CODES = Api::CODES

  #
  def api_online opts
    return CODES[:role_have_online] if self.online
		return CODES[:role_server_is_nil] if self.server.blank?
    return CODES[:role_has_closed] if self.close
    # get computer
    computer = Computer.find_by_auth_key(opts[:ckey])
    return CODES[:not_find_computer] unless computer
		return CODES[:computer_unchecked] unless computer.checked
		max_roles_count = Setting.find_value_by_key("computer_max_roles_count")
		return CODES[:full_use_computer] if max_roles_count && computer.roles_count >= max_roles_count 
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
		return CODES[:role_not_online] unless self.online
		return CODES[:computer_error] unless opts[:cid] && opts[:cid].to_i == self.computer_id 
    ip = Ip.find_by_value(opts[:ip] || self.ip)
    ip = Ip.create(:value => opts[:ip]) unless ip
    self.transaction do
       return CODES[:role_not_online] unless self.online
       self.computer.update_attributes(:roles_count=>self.computer.roles_count-1) if self.computer && self.computer.roles_count > 0
       ip.update_attributes(:use_count=>ip.use_count-1) if ip.use_count > 0
       Note.create(:role_id=>self.id,:computer_id=>self.computer_id,:ip=>ip.value,:api_name=>"offline")
       return 1 if self.update_attributes(:online=>false,:computer_id=>0,:ip=>nil)
    end
  end

  #
  def api_sync opts
		 return CODES[:role_not_online] unless self.online
		 return CODES[:computer_error] unless opts[:cid] && opts[:cid].to_i == self.computer.id 
     self.role_index = opts[:role_index] if opts[:role_index]
     self.server = opts[:server] if opts[:server]
     self.level = opts[:level] if opts[:level]
     self.vit_power = opts[:vit_power] if opts[:vit_power]
     self.gold = opts[:gold] if opts[:gold]
     #...
     self.transaction do
      #Note.create(:role_id=>self.id,:computer_id=>self.computer_id,:ip=>opts[:ip],:api_name=>"sync")
			self.total = self.total_pay + self.gold if self.gold_changed?
      return 1 if self.save
     end
  end

  def api_close opts
		#return CODES[:role_not_online] unless self.online
		return CODES[:computer_error] unless opts[:cid] && opts[:cid].to_i == self.computer.id 
     self.transaction do
			roles = self.same_account_roles
			roles.each do |role|
					role.update_attributes(:close=>true,:close_hours=>opts[:h].to_i,:closed_at => Time.now,:reopen_at=>Time.now.ago(-opts[:h].to_i.hours))
					Note.create(:role_id=>role.id,:ip=>opts[:ip],:api_name=>"close",:computer_id=>self.computer.id)
			end
      
      return 1
   end
  end

	def api_note opts
		return CODES[:role_not_online] unless self.online
		return CODES[:computer_error] unless opts[:cid] && opts[:cid].to_i == self.computer.id 
		ip = Ip.find_by_value(opts[:ip] || self.ip)
    ip = Ip.create(:value => opts[:ip]) unless ip
		self.transaction do
			return 1 if Note.create(:role_id=>self.id,:computer_id=>self.computer_id,:ip=>ip.value,:api_name=>"",:api_code=>opts[:code]||0)
		end
	end


	def pay	opts
		return CODES[:role_not_online] unless self.online
		return CODES[:computer_error] unless opts[:cid] && opts[:cid].to_i == self.computer.id 
		ip = Ip.find_by_value(opts[:ip] || self.ip)
    ip = Ip.create(:value => opts[:ip]) unless ip
		self.transaction do
			note = Note.create(:role_id=>self.id,:computer_id=>self.computer.id,:ip=>ip.value,:api_name=>"pay")
			payment = Payment.new(:role_id=>self.id,:gold => opts[:gold],:balance => opts[:balance],:remark => opts[:remark],:note_id => note.id,:pay_type=>opts[:pay_type])	
			return CODES[:not_valid_pay] unless payment.valid? # validate not pass
			self.gold = payment.balance			 #当前金币 = 支出后的余额
			self.total_pay = self.total_pay + payment.gold # 累计支出
			self.total = payment.total = self.total_pay + payment.balance # 产出总和
			
			#payment.total = self.total_pay + payment.balance
			payment.save
			return 1 if  self.save
		end
	end

	#
	def api_add opts
			return CODES[:not_valid_role] unless self.valid?
			computer = Computer.find_by_auth_key(opts[:ckey])
			self.transaction do
					self.save
					note = Note.new(:role_id => self.id,:ip => opts[:ip],:api_name => "add_role")
					note.computer_id = computer.id if computer
					return 1 if note.save
			end
	end
	
	#重开角色的API
  def api_reopen opts
    self.transaction do
			self.same_account_roles.update_all(:close=>false,:closed_at=>nil,:close_hours=>nil,:reopen_at=>nil)
			return 1 if Note.create(:role_id=>self.id,:ip=>opts[:ip],:api_name=>"reopen")
    end
  end
end
