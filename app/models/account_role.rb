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
		unless opts[:started].blank?
			records = records.where("accounts.session_id = 0") if opts[:started].to_i == 0
			records = records.where("accounts.session_id > 0") if opts[:started].to_i == 1
		end
		unless opts[:bind].blank?
			records = opts[:bind] == "bind" ? records.where("bind_computer_id > 0") : records.where("accounts.bind_computer_id =?",opts[:bind].to_i)
		end
		records = records.where("date(accounts.created_at) = ?",opts[:a_created_at]) unless opts[:a_created_at].blank?
		#
		records = records.where("roles.id = ?",opts[:rid].to_i) unless opts[:rid].blank?
		records = records.where("roles.server like ?","%#{opts[:server]}%") unless opts[:r_server].blank?
		records = records.where("roles.role_index = ?",opts[:index].to_i) unless opts[:index].blank?
		records = records.where("roles.status in (?)",opts[:rss]) unless opts[:rss].blank?
		records = records.where("date(roles.created_at) = ?",opts[:r_created_at]) unless opts[:r_created_at].blank?
		records = records.where("roles.online = ?",opts[:online]) unless opts[:online].blank?
		records = records.where("roles.today_success =?",opts[:rts].to_i) unless opts[:rts].blank?
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

		records = records.reorder("accounts.id desc")
		return records


	end

	def self.get_accounts_list
		Account.joins("LEFT JOIN roles ON roles.account = accounts.no").includes(:bind_computer).uniq
	end

	def self.get_roles_list
		Role.joins(:qq_account)
	end

end