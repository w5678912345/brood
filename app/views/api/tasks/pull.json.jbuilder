json.code @code
if @code == 1
	json.set! :task do
	  json.(@task, :id,:name, :command,:args,:remark)
	end
end