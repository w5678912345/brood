json.code @code
if @code == 1
	json.set! :role do
	  json.(@role, :id,:account, :password,:server,:role_index,:computer_id,:level,:vit_power,:locked,:lost,:ip_range,:gold,:online_note_id,:sellers,:sell_goods,:goods_price)
	end
end