# encoding: utf-8
# @suxu
# 
class Api::ComputersController < Api::BaseController

	CODES = Api::CODES

	def reg
		@code = 0
		params[:ip] = request.remote_ip
		#test params
		params[:user_id] = User.first.id
			#-------------------
		user = User.find_by_id(params[:user_id])
		return @code = CODES[:not_find_user] unless user #not find user
		@computer = Computer.new(:hostname=>params[:hostname],:auth_key => params[:auth_key],:user_id=>user.id)
		return @code = CODES[:not_valid_computer] unless @computer.valid? #computer validate not pass
		begin
		  @computer.save
		  @code = 1 if  Note.create(:computer_id=>@computer.id,:ip=>params[:ip],:api_name=>"reg") 
		 rescue Exception => ex
		  @code = -1
		end
	end

	def set
		@code = 0
		@computer = Computer.find_by_auth_key(params[:ckey])
		return @code = CODES[:not_find_computer] unless @computer
		@code = 1 if @computer.update_attributes(:server=>params[:server])
		#render :partial => '/api/roles/result'
	end

end