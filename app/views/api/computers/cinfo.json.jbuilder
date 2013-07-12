json.code @code
if @code == 1
	json.set! :computer do
	  json.(@computer, :id,:server,:auth_key,:hostname,:roles_count)
	end
end