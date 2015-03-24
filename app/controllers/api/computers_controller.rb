# encoding: utf-8
# @suxu
# 
class Api::ComputersController < Api::BaseController

	CODES = Api::CODES

	before_filter :require_computer_by_ckey,:only =>[:start,:sync,:stop,:reset_accounts,:note,:bind_accounts]

	def reg
		@computer = Computer.find_by_auth_key(params[:auth_key])
		unless @computer
			@computer = Computer.new(:hostname=>params[:hostname],:auth_key => params[:auth_key],:server=>params[:server],:version=>params[:version]||"default",:user_id=>0,:real_name=>params[:real_name])
			@code = @computer.api_reg params
		else
			@code = 1 if @computer.update_attributes(:hostname => params[:hostname],:server=>params[:server],:version=>params[:version]||"default",:status=>1)
		end
	end

	def set
        @code = 0
        @computer = Computer.find_by_auth_key(params[:ckey])
        return @code = CODES[:not_find_computer] unless @computer
        @code = 1 if @computer.update_attributes(:server=>params[:server],:updated_at=>Time.now)
        @computer.clear_bind_accounts(opts={:ip=>request.remote_ip,:msg=>"clear by set server",:bind=>0}) if @code==1
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

	def reset_accounts
		@computer.account_sessions.each do |a|
			Accounts::StopService.new(a).run(false,'reset')
		end

		@code = 1
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
	def bind_accounts
		@accounts = @computer.accounts
	end

	private
	def require_computer_by_ckey
		@computer = Computer.find_by_auth_key(params[:ckey]) if params[:ckey]
		@code = CODES[:not_find_computer] unless @computer
		return render :partial => 'api/result' unless @code == 0	
	end



end