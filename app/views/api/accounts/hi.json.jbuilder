json.code @code
if @code == 1
	json.set! :account do
	  json.(@account, :id,:no, :password,:server,:status,:sellers,:sell_goods,:goods_price)
	  json.roles @account.roles, :id,:level,:role_index,:vit_power
	end
end
