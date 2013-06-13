json.code @code
if @code == 1
	json.set! :role do
	  json.(@role, :id,:account, :password,:server,:role_index,:computer_id,:level,:vit_power,:online)
	end
end