json.array! @roles do |role|
  json.set! :role do
	  json.(role, :id,:account, :password,:server,:role_index,:online,:level,:vit_power)
  end
end