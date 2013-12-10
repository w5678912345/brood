# encoding: utf-8
class AccountRole


	def self.get_list opts
		
		records = opts[:tag] == "role" ? get_roles_list : get_accounts_list
		records = records.where("accounts.id > 0")
		records = records.where("accounts.status in (?)",opts[:ass]) unless opts[:ass].blank?
		records = records.where("accounts.roles_count = ?",opts[:roles_count].to_i) unless opts[:roles_count].blank?
		records = records.where("accounts.bind_computer_id = ?",opts[:bind_cid].to_i) unless opts[:bind_cid].blank?
		records = records.where("date(accounts.created_at) = ?",opts[:a_created_at]) unless opts[:a_created_at].blank?
		#
		records = records.where("roles.id = ?",opts[:rid].to_i) unless opts[:rid].blank?
		records = records.where("date(roles.created_at) = ?",opts[:r_created_at]) unless opts[:r_created_at].blank?
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