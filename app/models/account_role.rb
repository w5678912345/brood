# encoding: utf-8
class AccountRole


	def self.get_list opts
		
		records = opts[:tag] == "role" ? get_roles_list : get_accounts_list
		records = records.where("accounts.id > 0")
		records = records.where("accounts.no = ?",opts[:no]) unless opts[:no].blank?
		records = records.where("accounts.status in (?)",opts[:ass]) unless opts[:ass].blank?
		records = records.where("accounts.server like ?","%#{opts[:server]}%") unless opts[:server].blank?
		records = records.where("accounts.roles_count = ?",opts[:roles_count].to_i) unless opts[:roles_count].blank?
		records = records.where("accounts.bind_computer_id = ?",opts[:bind_cid].to_i) unless opts[:bind_cid].blank?
		records = records.where("accounts.today_success =?",opts[:ts].to_i) unless opts[:ts].blank?
		records = records.where("accounts.online_ip = ?",opts[:online_ip]) unless opts[:online_ip].blank?
		records = records.where("accounts.online_role_id =?",opts[:online_rid]) unless opts[:online_rid].blank?
		records = records.where("accounts.is_auto = ?",opts[:auto].to_i) unless opts[:auto].blank?
		records = records.where("accounts.phone_id like ?","%#{opts[:phone]}%") unless opts[:phone].blank?
		records = records.where("accounts.normal_at >= ?",opts[:min_nat]) unless opts[:min_nat].blank?
        records = records.where("accounts.normal_at <= ?",opts[:max_nat]) unless opts[:max_nat].blank?
		records = records.where("accounts.enabled = ?",opts[:enabled]) unless opts[:enabled].blank?
		records = records.where("accounts.in_cpo = ?",opts[:in_cpo]) unless opts[:in_cpo].blank?
		records = records.where("accounts.standing = ?",opts[:standing]) unless opts[:standing].blank?


		unless opts[:started].blank?
			records = records.where("accounts.session_id = 0") if opts[:started].to_i == 0
			records = records.where("accounts.session_id > 0") if opts[:started].to_i == 1
		end
		unless opts[:bind].blank?
			records = opts[:bind] == "bind" ? records.where("bind_computer_id > 0") : records.where("accounts.bind_computer_id =?",opts[:bind].to_i)
		end
		unless opts[:bind_phone].blank?
        	records = opts[:bind_phone].to_i == 0 ? records.where("accounts.phone_id is null") : records.where("accounts.phone_id is not null")
      	end
		records = records.where("date(accounts.created_at) = ?",opts[:a_created_at]) unless opts[:a_created_at].blank?
		#
		records = records.where("roles.id = ?",opts[:rid].to_i) unless opts[:rid].blank?
		records = records.where("roles.name like ?","%#{opts[:rname]}%") unless opts[:rname].blank?
		records = records.where("roles.server like ?","%#{opts[:r_server]}%") unless opts[:r_server].blank?
		records = records.where("roles.role_index = ?",opts[:index].to_i) unless opts[:index].blank?
		records = records.where("roles.status in (?)",opts[:rss]) unless opts[:rss].blank?
		records = records.where("date(roles.created_at) = ?",opts[:r_created_at]) unless opts[:r_created_at].blank?
		records = records.where("roles.online = ?",opts[:online]) unless opts[:online].blank?
		records = records.where("roles.today_success =?",opts[:rts].to_i) unless opts[:rts].blank?
		records = records.where("roles.is_helper =?",opts[:is_helper].to_i) unless opts[:is_helper].blank?
		records = records.where("roles.ishell =?",opts[:ishell].to_i) unless opts[:ishell].blank?
		records = records.where("roles.profession = ?",opts[:profession]) unless opts[:profession].blank?
		records = records.where("roles.profession not in (?)",opts[:not_profession]) unless opts[:not_profession].blank?
		unless opts[:r_started].blank?
			records = records.where("roles.session_id = 0") if opts[:r_started].to_i == 0
			records = records.where("roles.session_id > 0") if opts[:r_started].to_i == 1
		end
		unless opts[:level].blank?
      tmp = opts[:level].split("-")
      records = tmp.length == 2 ? records.where("roles.level >= ? and roles.level <= ?",tmp[0],tmp[1]) : records.where("roles.level =? ",opts[:level].to_i)
	  end
    unless opts[:vit].blank?
      tmp = opts[:vit].split("-")
      records = tmp.length == 2 ? records.where("roles.vit_power >= ? and roles.vit_power <= ?",tmp[0],tmp[1]) : records.where("roles.vit_power =? ",opts[:vit].to_i)
    end
    unless opts[:gold].blank?
      tmp = opts[:gold].split("-")
      records = tmp.length == 2 ? records.where("roles.gold >= ? and roles.gold <= ?",tmp[0],tmp[1]) : records.where("roles.gold =? ",opts[:gold].to_i)
    end
	  unless opts[:money_point].blank?
      tmp = opts[:money_point].split("-")
      records = tmp.length == 2 ? records.where("roles.money_point >= ? and roles.money_point <= ?",tmp[0],tmp[1]) : records.where("roles.money_point =? ",opts[:gold].to_i)
	  end
		#records = records.reorder("accounts.id desc")
		return records


	end

	def self.get_accounts_list
		Account.joins("LEFT JOIN roles ON roles.account = accounts.no").includes(:bind_computer).uniq
	end

	def self.get_roles_list
		Role.joins(:qq_account)
	end

end