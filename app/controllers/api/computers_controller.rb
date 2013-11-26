# encoding: utf-8
# @suxu
# 
class Api::ComputersController < Api::BaseController

	CODES = Api::CODES

	before_filter :require_computer_by_ckey,:only =>[:start,:sync,:stop,:note]

	def reg
		@computer = Computer.new(:hostname=>params[:hostname],:auth_key => params[:auth_key],:server=>params[:server],:version=>params[:version]||"default",:user_id=>0)
		@code = @computer.api_reg params
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

	def start
		@code = @computer.api_start params
		render :partial => '/api/result'
	end

	def sync
		@code = @computer.api_sync(params)
		render :partial => '/api/result'
	end

	def note
		@code = @computer.api_note(params)
		render :partial => '/api/result'
	end

	def stop
		@code =  @computer.api_stop params
		render :partial => '/api/result'
	end

	private
	def require_computer_by_ckey
		@computer = Computer.find_by_auth_key(params[:ckey]) if params[:ckey]
		@code = CODES[:not_find_computer] unless @computer
		return render :partial => 'api/result' unless @code == 0	
	end



end