json.code @code
if @code == 1
	json.set! :account do
	  json.id @account.no

    json.(@account,:no, :password,:server,:status,:sellers,:anton_normal_at,:sell_goods,:goods_price,:point,:online_ip,:is_bind_phone,:phone_id,:standing)
    json.roles @account.roles, :id,:level,:role_index,:vit_power,:is_helper,:is_seller,:ishell,:channel_index,:status,:profession,:today_success,:gold
    json.helpers @account.helpers, :name,:channel_index,:profession

	end
end
