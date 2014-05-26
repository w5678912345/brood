# encoding: utf-8
# @suxu
# 
class Api::MapsController < Api::BaseController


	def valid

		@role = Role.find_by_id(params[:role_id])
		return render json: {:code => CODES[:not_find_role]} unless @role
		if @role.role_session.nil?
			return render json: {:code => CODES[:role_offline]}
		end
		if @role.role_session.instance_map
			@map = @role.role_session.instance_map
		else
			@map = InstanceMap.get_valid_one(@role.level)
		end
		@map = InstanceMap.get_valid_one(@role.level) if params[:new].to_i == 1
		if @map
			@role.role_session.instance_map = @map
			@role.role_session.save
			@map.enter_count = @map.enter_count+1
			@map.save
			render :json => {:key=>@map.key,:name=>@map.name}
		else
			@code = -1
			Note.create(@role.role_session.computer.to_note_hash.merge(:account=>@role.account, :role_id => @role.id, :api_name=>"not_find_map",:ip=>request.remote_ip))
			render :json => {:code=>@code}
		end
		
	end


	# level = params[:level].blank? ? @role.level : params[:level].to_i

	# 	@map = InstanceMap.level_scope(level).safety_scope(level).first

	# 	@map = InstanceMap.level_scope(level).death_scope(level).first unless @map
	# 	unless @map
	# 		return render json: {:code => -1, :msg =>"not find map"}
	# 	end
	# 	render :json => {:code=>1, :id => @map.id ,:name=>@map.name}
end