# encoding: utf-8
class Service
	attr_accessor :user
	attr_accessor :pass
	attr_accessor :msgs
	

	def initialize()
		@msgs = Hash.new
	end

	#
	def new_role(opts = Hash.new)
		Role.new(opts)
	end

	#
	def create_role(opts)
		role = self.new_role(opts)
		self.pass = role.save
		return role
	end




end