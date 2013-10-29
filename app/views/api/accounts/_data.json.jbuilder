json.code @code
if @code == 1
	json.set! :account do
	  json.id @account.no
	  json.(@account,:no, :password,:server,:status,:sellers,:sell_goods,:goods_price)
	  if @auto
	  	json.roles @account.available_roles, :id,:level,:role_index,:vit_power
	  else
	  	json.roles @account.roles, :id,:level,:role_index,:vit_power
	  end
	  
	end
end
