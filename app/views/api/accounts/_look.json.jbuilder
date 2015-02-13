json.code @code
if @code == 1
	json.set! :account do
	  json.id @account.no

    json.(@account,:no, :password,:server,:status,:sellers,:sell_goods,:goods_price,:point,:online_ip,:is_bind_phone,:phone_id,:standing)
    json.roles @account.roles, :id,:level,:role_index,:vit_power,:is_helper,:ishell,:channel_index,:status,:profession,:today_success
    json.helpers @account.helpers, :name,:channel_index,:profession

	end
end
