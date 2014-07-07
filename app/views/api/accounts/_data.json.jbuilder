

json.code @code
if @code == 1
	helper_role = @account.helper_role
	json.set! :account do
	  json.id @account.no
	  json.(@account,:no, :password,:server,:status,:sellers,:sell_goods,:goods_price,:online_ip,:is_bind_phone,:phone_id)
	  json.roles @account.online_roles, :id,:level,:role_index,:vit_power,:is_helper
	  if helper_role
	  	json.helper_name helper_role.name
	  	json.helper_channel_index helper_role.channel_index
	  else
	  	json.helper_name ''
	  	json.channel_index -1
	  end
	  
	end
end
