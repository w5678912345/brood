# encoding: utf-8
# @suxu
# 
class Api::ComputersController < Api::BaseController

	CODES = Api::CODES

	before_filter :require_computer_by_ckey,:only =>[:start,:stop]

	def reg
		@code = 0
		params[:ip] = request.remote_ip
		#test params
		params[:user_id] = User.first.id
			#-------------------
		user = User.find_by_id(params[:user_id])
		return @code = CODES[:not_find_user] unless user #not find user
		@computer = Computer.new(:hostname=>params[:hostname],:auth_key => params[:auth_key],:user_id=>user.id,:server=>params[:server])
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
		@code = 1 if @computer.update_attributes(:server=>params[:server],:updated_at=>Time.now)
		render :partial => '/api/result'
	end

	def cinfo
		@code = 0
		@computer = Computer.find_by_auth_key(params[:ckey])
		return @code = CODES[:not_find_computer] unless @computer
		@code = 1 if @computer
	end

	def disable
		@computer = Computer.find_by_auth_key(params[:ckey])
		unless @computer
		  @code = CODES[:not_find_computer]
		 	return render :partial => '/api/result'
		end
		
		if @computer.update_attributes(:status=>0)
			Note.create(:role_id => 0,:ip=>params[:ip],:computer_id=>@computer.id,:api_name => "computer_disable",:api_code=>params[:code],:msg => params[:msg]) 
			@code = 1
		end
		render :partial => '/api/result'
	end

	def note
		@computer = Computer.find_by_auth_key(params[:ckey])
		@code = CODES[:not_find_computer] unless @computer
		if @computer
			@code = 1 if Note.create(:role_id => 0,:ip=>params[:ip],:computer_id=>@computer.id,:api_name => params[:event] || "default",:api_code=>params[:code],:msg => params[:msg]) 
		end
		render :partial => '/api/result'

	end


	def start
		@code = 1 if @computer.start params
		render :partial => '/api/result'
	end

	def stop
		@code = 1 if @computer.stop params
		render :partial => '/api/result'
	end

	def require_computer_by_ckey
		@computer = Computer.find_by_auth_key(params[:ckey]) if params[:ckey]
		@code = CODES[:not_find_computer] unless @computer

		return render :partial => 'api/result' unless @code == 0	
	end



end