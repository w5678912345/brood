# encoding: utf-8
class AccountRole


	def self.get_list opts
		records = Account.joins("LEFT JOIN roles ON roles.account = accounts.no").includes(:bind_computer)
		records = Role.joins(:qq_account) if opts[:tag] == "role"
		records = records.where("accounts.id > 0").uniq
		#records = records.where("accounts.id > 6000")
		records = records.reorder("accounts.id desc")
		return records
	end

end