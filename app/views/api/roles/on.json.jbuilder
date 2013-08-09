json.code @code
if @code == 1
	json.set! :role do
	  json.(@role, :id,:account, :password,:server,:role_index,:computer_id,:level,:vit_power,:locked,:lost,:gold)
	end
	json.set! :seller do
	if @seller
	  json.(@seller, :id,:account, :password,:server,:role_index,:computer_id,:level,:vit_power,:locked,:lost,:is_seller)
	end
	end
end