

json.code @code
if @code == 1
	json.set! :account do
	  json.id @account.no
    json.profile_name @account.account_profile.name if @account.account_profile
	  json.(@account,:no, :password,:server,:status,:anton_normal_at,:today_pay_count,:gold_agent_level,:sellers,:sell_goods,:goods_price,:point,:online_ip,:is_bind_phone,:phone_id,:standing)
	  json.roles @online_roles, :id,:level,:role_index,:vit_power,:is_helper,:is_seller,:ishell,:channel_index,:profession
	  json.helpers @account.helpers, :name,:channel_index,:profession
	end
end
