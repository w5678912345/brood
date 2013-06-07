json.code @code
if @code == 1
	json.set! :role do
	  json.(@role, :id,:account, :password,:server,:name,:computer_id)
	end
end