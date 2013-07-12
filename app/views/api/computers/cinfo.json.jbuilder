json.code @code
if @code == 1
	json.set! :computer do
	  json.(@computer, :id,:server,:auth_key,:hostname,:roles_count,:checked)
	end
end