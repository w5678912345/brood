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
		# if @role.role_session.instance_map
		# 	@map = @role.role_session.instance_map
		# 	#return render :json => {:key=>@map.key,:name=>@map.name,:ishell=>@map.ishell} if @map
		# end
		#@map = InstanceMap.get_valid_one(params[:level].to_i) unless params[:level].blank?
		@role.role_session.instance_map = nil #.update_attributes(:instance_map_id=>0)
		@role.role_session.save

		#@map = InstanceMap.find_by_role_session(@role.role_session)
		@map = InstanceMap.find_by_role(@role,{:ishell=>params[:ishell],:exgroup => params[:exgroup],:expect_map_name => params[:expect_map_name]}) unless @map

		if @map
			@role.role_session.instance_map = @map
			@role.role_session.save

			render :json => {:key=>@map.key,:name=>@map.name,:ishell=>@map.ishell}
		else
			Note.create(@role.role_session.computer.to_note_hash.merge(:account=>@role.account, :role_id => @role.id, :api_name=>"not_find_map",:ip=>request.remote_ip))
			@code = -1
			render :json => {:code=>@code,:msg=>"not find map"}
		end
		
	end

	def index
		@role = Role.find_by_id(params[:role_id])
		return render json: {:code => CODES[:not_find_role]} unless @role
		if @role.role_session.nil?
			return render json: {:code => CODES[:role_offline]}
		end
		prof_maps = InstanceMap.level_scope(@role.level).where(:profession => @role.profession)		
		share_maps = InstanceMap.level_scope(@role.level).where(:profession => "all")		
		@maps = (prof_maps + share_maps).uniq
	end
	def enter
		@role = Role.find_by_id(params[:role_id])
		return render json: {:code => CODES[:not_find_role]} unless @role
		if @role.role_session.nil?
			return render json: {:code => CODES[:role_offline]}
		end

		@map = InstanceMap.find_by_id(params[:map_id])
		if @map.nil?
			return render json: {:code => CODES[:errors],:msg => 'can\'t find map by map_id'}
		end
		@role.role_session.instance_map = @map
		@role.role_session.save
		return render json: {:code => CODES[:success]}
	end
	# level = params[:level].blank? ? @role.level : params[:level].to_i

	# 	@map = InstanceMap.level_scope(level).safety_scope(level).first

	# 	@map = InstanceMap.level_scope(level).death_scope(level).first unless @map
	# 	unless @map
	# 		return render json: {:code => -1, :msg =>"not find map"}
	# 	end
	# 	render :json => {:code=>1, :id => @map.id ,:name=>@map.name}
end