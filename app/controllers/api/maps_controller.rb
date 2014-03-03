# encoding: utf-8
# @suxu
# 
class Api::MapsController < Api::BaseController


	def valid
		@role = Role.find_by_id(params[:role_id])
		return render json: {:code => CODES[:not_find_role]} unless @role
		level = @role.level
		@map = InstanceMap.level_scope(level).safety_scope.first
		
		if @map
			@map.enter_count = @map.enter_count+1
			@map.save
			render :json => {:key=>@map.key,:name=>@map.name}
		else
			@code = -1
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